# INFO: Kubernetes Service Manifest (Type: Load Balancer)
# ? https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_v1

resource "kubernetes_service_v1" "lb_service" {
  metadata {
    name = "myapp1-lb-service-clb"
  }
  spec {
    selector = {
      # NOTE: Targets for this selector are defined in the deployment configuration (c10-kubernetes-deployment.tf)
      # NOTE: spec and selectors are nested blocks and could contain multiple configurations, hence "0"
      #app = kubernetes_deployment_v1.myapp1.spec.0.template.0.metadata[0].labels.app
      app = kubernetes_deployment_v1.myapp1.spec.0.selector.0.match_labels.app 
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"

  }
}