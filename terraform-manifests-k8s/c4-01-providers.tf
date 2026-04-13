# INFO: Provider Block

# INFO: AWS
provider "aws" {
  region = var.aws_region
  # NOTE: Profile only required when running Terraform locally on your desktop/laptop. CI/CD will be configured in a different way.
  //profile = "default" # NOTE: AWS Credentials Profile (profile = "default") configured on your local desktop terminal ($HOME/.aws/credentials)
}

# INFO: Kubernetes
# ? aws_eks_cluster: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster
# ? aws_eks_cluster_auth: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth

data "aws_eks_cluster" "eks_cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
}