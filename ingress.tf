resource "kubernetes_ingress_v1" "this" {
  metadata {
    name      = local.full_name
    namespace = var.namespace

    labels = local.labels
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = "localhost"

      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"

          backend {
            service {
              name = local.full_name

              port {
                number = 7890
              }
            }
          }
        }

        path {
          path      = "/"
          path_type = "ImplementationSpecific"

          backend {
            service {
              name = local.full_name

              port {
                number = 7891
              }
            }
          }
        }

        path {
          path      = "/"
          path_type = "ImplementationSpecific"

          backend {
            service {
              name = local.full_name

              port {
                number = 7778
              }
            }
          }
        }
      }
    }
  }
}
