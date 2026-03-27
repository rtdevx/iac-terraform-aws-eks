# INFO: Create VPC using Terraform Module
# ? https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.4.0"

  name = "${local.name}-vpc"
  cidr = var.vpc_cidr

  azs = local.azs

  private_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  public_subnets   = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 4)]
  database_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 8)]

  create_database_subnet_group       = true
  create_database_subnet_route_table = true

  enable_nat_gateway = true
  single_nat_gateway = var.environment == "prod" ? false : true # NOTE: Only in non-prod regions.

  map_public_ip_on_launch = true # NOTE: Required for EKS (ERROR if missing: One or more Amazon EC2 Subnets of [] for node group ops-dev-eks-eks-ng-public does not automatically assign public IP addresses to instances launched into it.)

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.common_tags
}