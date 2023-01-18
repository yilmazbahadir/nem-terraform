resource "kubernetes_ingress_v1" "this" {
  count = var.ingress_enabled ? 1 : 0
  metadata {
    name      = local.full_name
    namespace = var.namespace

    labels = local.labels
  }

  spec {
    ingress_class_name = var.ingress_class_name

    dynamic "tls" {
      for_each = var.ingress_tls

      content {
        hosts       = tls.value.hosts
        secret_name = tls.value.secret_name
      }
    }

    dynamic "rule" {
      for_each = var.ingress_rules

      content {
        host = rule.value.host

        http {
          dynamic "path" {
            for_each = rule.value.paths

            content {
              path      = path.value.path
              path_type = path.value.path_type

              backend {
                service {
                  name = local.full_name

                  port {
                    number = path.value.backend_service_port
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
