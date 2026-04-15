# INFO: Terraform Block
# ? Terraform Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#example-usage
# ? Kubernetes Provider: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs

terraform {
  required_version = "~> 1.13.0" # NOTE: Greater than 1.13.0. Only the most upright version number (.0) can change.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" # NOTE: Greater than 6.0. Only the most upright version number (.0) can change.
    }
    helm = {
      source = "hashicorp/helm"
      #version = "2.4.1"
      #version = "~> 2.4"
      version = "~> 2.9"
    }
    http = {
      source = "hashicorp/http"
      #version = "2.1.0"
      #version = "~> 2.1"
      version = "~> 3.3"
    }
  }

  # INFO: S3 Backend Block
  backend "s3" {
    # NOTE: Backend configuration moved to 'env_ENVIRONMENT.conf' files to support multiple environments. Executing backend configuration within CI/CD pipeline `terraform init -backend-config=env_dev.conf`
    # ? https://developer.hashicorp.com/terraform/cli/commands/init
  }
}