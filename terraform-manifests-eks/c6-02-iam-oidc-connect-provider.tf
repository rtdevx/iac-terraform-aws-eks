# INFO: Datasource: AWS Partition

# NOTE: Use this data source to lookup information about the current AWS partition in which Terraform is working (example partitions: aws, aws-cn - aws China)
# ? https://registry.terraform.io/providers/-/aws/latest/docs/data-sources/partition

data "aws_partition" "current" {}

# INFO: Resource: AWS IAM Open ID Connect Provider
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider.html

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.${data.aws_partition.current.dns_suffix}"]
  thumbprint_list = [var.eks_oidc_root_ca_thumbprint]
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer

  # NOTE: Merging multiple maps
  # ? https://developer.hashicorp.com/terraform/language/functions/merge

  tags = merge(
    {
      Name = "${var.cluster_name}-eks-irsa"
    },
    local.common_tags
  )
}

# INFO: Outputs

# NOTE: Output: AWS IAM Open ID Connect Provider ARN
output "aws_iam_openid_connect_provider_arn" {
  description = "AWS IAM Open ID Connect Provider ARN"
  value       = aws_iam_openid_connect_provider.oidc_provider.arn
}

# NOTE: Output: AWS IAM Open ID Connect Provider
output "aws_iam_openid_connect_provider_extract_from_arn" {
  description = "AWS IAM Open ID Connect Provider extract from ARN"
  value       = local.aws_iam_oidc_connect_provider_extract_from_arn # NOTE: value extracted from splitting above output. See below "locals".
}

# INFO: Locals

# NOTE: Extract OIDC Provider from OIDC Provider ARN
# ? https://developer.hashicorp.com/terraform/language/functions/split

locals {
  aws_iam_oidc_connect_provider_extract_from_arn = element(split("oidc-provider/", "${aws_iam_openid_connect_provider.oidc_provider.arn}"), 1)
}

# NOTE: Split explain

# Sample Outputs for Reference
/*
aws_iam_openid_connect_provider_arn = "arn:aws:iam::180789647333:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/A9DED4A4FA341C2A5D985A260650F232"
aws_iam_openid_connect_provider_extract_from_arn = "oidc.eks.us-east-1.amazonaws.com/id/A9DED4A4FA341C2A5D985A260650F232"
*/

# String to split: 
/*
"arn:aws:iam::180789647333:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/A9DED4A4FA341C2A5D985A260650F232"

String split at "oidc-provider/"

Split creates 2 list items:
0: "arn:aws:iam::180789647333:oidc-provider/
1: oidc.eks.us-east-1.amazonaws.com/id/A9DED4A4FA341C2A5D985A260650F232"

in our split function, we are associating a variable (aws_iam_openid_connect_provider.oidc_provider.arn) with element 1 (oidc.eks.us-east-1.amazonaws.com/id/A9DED4A4FA341C2A5D985A260650F232) and disregarding element 0 (arn:aws:iam::180789647333:oidc-provider/)

First element is then output (see above outputs section):
output "aws_iam_openid_connect_provider_extract_from_arn"
*/