# INFO: Kubernetes Service Manifest (Type: Load Balancer)

resource "kubernetes_service_v1" "lb_service" {
  metadata {
    name = "myapp1-lb-service-clb"
  }
  spec {
    selector = {
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