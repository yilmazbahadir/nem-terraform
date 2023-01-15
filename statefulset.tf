locals {
  volume_config_items = { for map_item in [
    { key = "configuser.properties", value = { path = "configuser.properties", mount_path = "/usersettings/config-user.properties", content = var.configuser_properties } },
    { key = "logalpha.properties", value = { path = "logalpha.properties", mount_path = "/usersettings/logalpha.properties", content = var.logalpha_properties } },
    { key = "db.properties", value = { path = "db.properties", mount_path = "/usersettings/db.properties", content = var.db_properties } },
    { key = "nemesis-file", value = { path = "nemesis-file", mount_path = "/usersettings/custom-nemesis.bin", content = var.nemesis_file_base64 } },
    { key = local.peers_json_filename, value = { path = local.peers_json_filename, mount_path = "/usersettings/${local.peers_json_filename}", content = var.peers_config_json } }
  ] : map_item.key => map_item.value if map_item.value.content != "" }
}

resource "kubernetes_stateful_set" "statefulset" {
  metadata {
    name   = local.full_name
    labels = local.labels
  }

  spec {
    replicas = 1

    selector {
      match_labels = local.labels
    }

    template {
      metadata {
        labels = local.labels

        annotations = var.annotations
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = local.full_name

            dynamic "items" {
              for_each = local.volume_config_items

              content {
                key  = items.key
                path = items.value.path
              }
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
          name  = var.name
          image = local.image_name

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

          dynamic "volume_mount" {
            for_each = local.volume_config_items

            content {
              name       = "config"
              mount_path = volume_mount.value.mount_path
              sub_path   = volume_mount.value.path
            }
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

    service_name          = "${local.full_name}-headless"
    pod_management_policy = var.pod_management_policy

    update_strategy {
      type = var.update_strategy
    }
  }
}
