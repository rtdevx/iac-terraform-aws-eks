# INFO: Terraform Remote State Datasource (of the EKS Cluster!)

data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket = "rk-backend"
    key    = "iac-terraform-aws-eks/${var.environment}-terraform-eks.tfstate"
    region = "eu-west-2"
  }
}