# INFO: Kubernetes Service Manifest (Type: Load Balancer)
# ? https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_v1

resource "kubernetes_service_v1" "lb_service_nlb" {
  metadata {
    name = "myapp1-lb-service-nlb"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb" # NOTE: To create Network Load Balancer
    }
  }
  spec {
    selector = {
      # NOTE: Targets for this selector are defined in the deployment configuration (c10-kubernetes-deployment.tf)
      # NOTE: spec and selectors are nested blocks and could contain multiple configurations, hence "0"
      app = kubernetes_deployment_v1.myapp1.spec.0.selector.0.match_labels.app
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"

  }
}