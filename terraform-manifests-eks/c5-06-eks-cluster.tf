# INFO: Build EKS Cluster
# ? https://registry.terraform.io/providers/-/aws/latest/docs/resources/eks_cluster

# NOTE: Create AWS EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = "${local.name}-${var.cluster_name}"
  role_arn = aws_iam_role.eks_master_role.arn
  version  = var.cluster_version # ? Cluster Versions: https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html

  vpc_config {
    subnet_ids              = module.vpc.public_subnets                # NOTE: This is where ENI's will be created as part of this resource
    endpoint_public_access  = var.cluster_endpoint_public_access       # NOTE: EKS public API server endpoint
    endpoint_private_access = var.cluster_endpoint_private_access      # NOTE: EKS private API server endpoint
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs # NOTE: Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled.
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_service_ipv4_cidr # NOTE: CIDR for the Kubernetes cluster itself
  }

  # NOTE: Enable EKS Cluster Control Plane Logging
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # NOTE: Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling, otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController,
  ]
}