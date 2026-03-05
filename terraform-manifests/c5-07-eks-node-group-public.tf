# INFO: Create AWS EKS Node Group - public
# ? https://registry.terraform.io/providers/-/aws/latest/docs/resources/eks_node_group

/*

# TODO: Consider using Launch Template insteaed of aws_eks_node_group. Investigate pros and cons.
resource "aws_eks_node_group" "eks_ng_public" {
  cluster_name = aws_eks_cluster.eks_cluster.name

  node_group_name = "${local.name}-eks-ng-public"
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids      = module.vpc.public_subnets
  version = var.cluster_version # NOTE: If not present, nodes will not be updated as part of cluster upgrade

  #ami_type = "AL2_x86_64" # Not compatible with ~> 1.32 Kubernetes
  ami_type       = "AL2023_x86_64_STANDARD" # ? https://docs.aws.amazon.com/eks/latest/APIReference/API_Nodegroup.html#AmazonEKS-Type-Nodegroup-amiType  
  capacity_type  = "ON_DEMAND"
  disk_size      = 20
  instance_types = [var.instance_type_public]

  # TODO: To be replaced with SSM access, no Bastion host present in this configuration
  # ! If you specify this configuration, but do not specify source_security_group_ids when you create an EKS Node Group, either port 3389 for Windows, or port 22 for all other operating system  
  # ? https://registry.terraform.io/providers/-/aws/latest/docs/resources/eks_node_group#remote_access-configuration-block

  # remote_access {
  #   ec2_ssh_key = "eks-terraform-key"
  # }

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 2
  }

  # NOTE: Desired max percentage of unavailable worker nodes during node group update.
  update_config {
    max_unavailable = 1
    #max_unavailable_percentage = 50
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = {
    Name = "Public-Node-Group"
  }
}

*/