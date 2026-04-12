# INFO: Input Variables - AWS IAM OIDC Connect Provider

# NOTE: EKS OIDC ROOT CA Thumbprint - valid until 2037

# OPTIMIZE: It is possible to get the data from AWS. Not urgent (valid until 2037) but better practice.
variable "eks_oidc_root_ca_thumbprint" {
  type        = string
  description = "Thumbprint of Root CA for EKS OIDC, Valid until 2037"
  default     = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
}