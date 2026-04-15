# INFO: EBS CSI IAM Policy get from EBS GIT Repo (latest)
# ? https://registry.terraform.io/providers/terraform-aws-modules/http/latest/docs/data-sources/http

# NOTE: The http data source makes an HTTP GET request to the given URL and exports information about the response. It requires it's own provider: https://registry.terraform.io/providers/hashicorp/http/latest/docs

data "http" "ebs_csi_iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/docs/example-iam-policy.json"

  # NOTE: Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}

# INFO: Outputs

output "ebs_csi_iam_policy" {
  #value = data.http.ebs_csi_iam_policy.body
  value = data.http.ebs_csi_iam_policy.response_body
}

/*
This http data will download IAM policy information from AWS EBS CSI Driver GitHub repository.
This information is used later in "c4-02-ebs-csi-iam-policy-and-role.tf" to build EBS CSI Policy.

Instead of providing the policy details, it can be downloaded with http data.
*/