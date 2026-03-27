# INFO: Terraform Block
# ? Terraform Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#example-usage
# ? Kubernetes Provider: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs

terraform {
  required_version = "~> 1.13.0" # NOTE: Greater than 1.13.2. Only the most upright version number (.0) can change.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" # NOTE: Greater than 6.0. Only the most upright version number (.0) can change.
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 3.0"
    }
  }

  # INFO: S3 Backend Block
  backend "s3" {
    # NOTE: Backend configuration moved to 'env_ENVIRONMENT.conf' files to support multiple environments. Executing backend configuration within CI/CD pipeline `terraform init -backend-config=env_dev.conf`
    # ? https://developer.hashicorp.com/terraform/cli/commands/init
  }
}

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
  name = aws_eks_cluster.eks_cluster.id
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = aws_eks_cluster.eks_cluster.id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
}