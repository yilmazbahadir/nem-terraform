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
      port     = 7890
    }

    port {
      name     = "https"
      protocol = "TCP"
      port     = 7891
    }

    port {
      name     = "7778-tcp"
      protocol = "TCP"
      port     = 7778
    }

    selector = local.labels
    type     = "ClusterIP"
  }
}
