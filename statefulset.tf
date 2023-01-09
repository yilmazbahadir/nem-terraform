resource "kubernetes_stateful_set" "statefulset" {
  metadata {
    name = "statefulset"

    labels = templatefile("${path.module}/common/labels.tftpl", {})
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "release-name"
        "app.kubernetes.io/name" = "nem-client"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/instance" = "release-name"
          "app.kubernetes.io/name" = "nem-client"
        }

        annotations = {
          "checksum/config" = "d9a11eb3c3ae41b3e6d27bb697a6e4211081a876469deb090d8f2e30d9a15555"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "release-name-nem-client"

            items {
              key  = "configuser.properties"
              path = "configuser.properties"
            }
          }
        }

        init_container {
          name    = "init-chown-data"
          image   = "busybox:1.35.0"
          command = ["chown", "-R", "11001:11001", "/app/data"]

          volume_mount {
            name       = "nem-data"
            mount_path = "/app/data"
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            run_as_user = 0
          }
        }

        container {
          name  = "nem-client"
          image = "nemofficial/nis-client:0.6.100@sha256:8ccfdb5de8cfce01c91c599fe2c91ddafe74940923e3d1bda667137747dd7dcd"

          port {
            name           = "http"
            container_port = 7890
            protocol       = "TCP"
          }

          port {
            name           = "https"
            container_port = 7891
            protocol       = "TCP"
          }

          port {
            name           = "7778-tcp"
            container_port = 7778
            protocol       = "TCP"
          }

          volume_mount {
            name       = "nem-data"
            mount_path = "/app/data"
          }

          volume_mount {
            name       = "config"
            mount_path = "/usersettings/config-user.properties"
            sub_path   = "configuser.properties"
          }

          liveness_probe {
            tcp_socket {
              port = "http"
            }

            initial_delay_seconds = 60
            period_seconds        = 120
          }

          readiness_probe {
            tcp_socket {
              port = "http"
            }

            initial_delay_seconds = 60
            period_seconds        = 10
          }

          image_pull_policy = "IfNotPresent"
        }

        termination_grace_period_seconds = 300
        service_account_name             = "nem-client"

        security_context {
          run_as_user     = 11001
          run_as_group    = 11001
          run_as_non_root = true
          fs_group        = 11001
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "nem-data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "8Gi"
          }
        }

        storage_class_name = "local-path"
      }
    }

    service_name          = "nem-client-headless"
    pod_management_policy = "OrderedReady"

    update_strategy {
      type = "RollingUpdate"
    }
  }
}