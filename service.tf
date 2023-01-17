resource "kubernetes_service" "this" {
  metadata {
    name      = local.full_name
    labels    = local.labels
    namespace = var.namespace
  }

  spec {
    port {
      name     = "http"
      protocol = "TCP"
      port     = var.configuser_http_port
    }

    port {
      name     = "https"
      protocol = "TCP"
      port     = var.configuser_https_port
    }

    port {
      name     = "7778-tcp"
      protocol = "TCP"
      port     = var.configuser_websocket_port
    }

    selector = local.labels
    type     = "ClusterIP"
  }
}
