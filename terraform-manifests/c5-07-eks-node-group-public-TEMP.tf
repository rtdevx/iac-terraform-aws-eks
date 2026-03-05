# INFO: Create AWS EKS Node Group - public
# Includes a Launch Template that attaches a test Security Group (opens NodePort range).
# Quick-test only — do NOT keep in production.

# Launch Template to attach test Security Group to nodes (quick test only)
resource "aws_launch_template" "eks_nodegroup_lt" {
  name_prefix = "${local.name}-eks-ng-lt-"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.eks_nodes_sg.id]
  }

block_device_mappings {
  device_name = "/dev/sda1"
  ebs {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
  }
}

  lifecycle {
    create_before_destroy = true
  }

  tags = local.common_tags
}

resource "aws_eks_node_group" "eks_ng_public" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${local.name}-eks-ng-public"
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids      = module.vpc.public_subnets
  version         = var.cluster_version

  ami_type       = "AL2023_x86_64_STANDARD"
  capacity_type  = "ON_DEMAND"
  instance_types = [var.instance_type_public]

  # Use the launch template so nodes are created with the test SG
  launch_template {
    id      = aws_launch_template.eks_nodegroup_lt.id
    version = aws_launch_template.eks_nodegroup_lt.latest_version
  }

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure IAM role policy attachments exist before creating the node group
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
    aws_launch_template.eks_nodegroup_lt,
  ]

  tags = {
    Name = "Public-Node-Group"
  }
}