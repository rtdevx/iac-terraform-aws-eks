# INFO: Terraform Remote State Datasource

data "terraform_remote_state" "eks" {
  backend = "s3"

# HACK: EKS Cluster is being built with environment-specific state file (../terramform-manifests-eks/env_${var.env}.conf). Below is hard-coded and this method must change to reflect multi-env approach.
  config = {
    bucket = "rk-backend"
    key    = "iac-terraform-aws-eks/dev-terraform-eks.tfstate"
    region = "eu-west-2"
  }
}