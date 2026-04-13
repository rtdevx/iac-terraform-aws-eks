# INFO: Kubernetes Job
# ? https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/job_v1

resource "kubernetes_job_v1" "irsa_demo" {
  metadata {
    name = "irsa-demo"
  }
  spec {
    template {
      metadata {
        labels = {
          app = "irsa-demo"
        }
      }
      spec {
        service_account_name = kubernetes_service_account_v1.irsa_demo_sa.metadata.0.name # NOTE: 0 is required for a nested blocks to target the resource
        container {
          name  = "irsa-demo"
          image = "amazon/aws-cli:latest"
          args  = ["s3", "ls"]
          #args = ["ec2", "describe-instances", "--region", "${var.aws_region}"] # Should fail as we don't have access to EC2 Describe Instances for IAM Role
        }
        restart_policy = "Never"
      }
    }
  }
}