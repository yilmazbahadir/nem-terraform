locals {
  volume_config_items = { for map_item in [
    { key = "configuser.properties", value = { path = "configuser.properties", mount_path = "/usersettings/config-user.properties", content = local.configuser_properties_content } },
    { key = "logalpha.properties", value = { path = "logalpha.properties", mount_path = "/usersettings/logalpha.properties", content = var.logalpha_properties } },
    { key = "db.properties", value = { path = "db.properties", mount_path = "/usersettings/db.properties", content = var.db_properties } },
    { key = "nemesis-file", value = { path = "nemesis-file", mount_path = "/usersettings/custom-nemesis.bin", content = var.nemesis_file_base64 } },
    { key = local.peers_json_filename, value = { path = local.peers_json_filename, mount_path = "/usersettings/${local.peers_json_filename}", content = var.peers_config_json } }
  ] : map_item.key => map_item.value if map_item.value.content != "" }
}

resource "kubernetes_stateful_set" "this" {
  metadata {
    name      = local.full_name
    labels    = local.labels
    namespace = var.namespace
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
        dynamic "volume" {
          for_each = var.persistence_enabled ? [] : [1]
          content {
            name = "nem-data"
            empty_dir {}
          }
        }

        init_container {
          name    = "init-chown-data"
          image   = "${var.init_chown_data.image.repository}:${var.init_chown_data.image.tag}"
          command = ["chown", "-R", "${var.pod_security_context.runAsUser}:${var.pod_security_context.runAsGroup}", var.configuser_nem_folder]

          volume_mount {
            name       = "nem-data"
            mount_path = var.configuser_nem_folder
          }

          image_pull_policy = var.init_chown_data.image.pull_policy

          security_context {
            run_as_user = 0
          }
        }

        container {
          name  = var.name
          image = local.image_name

          port {
            name           = "http"
            container_port = var.configuser_http_port
            protocol       = "TCP"
          }

          port {
            name           = "https"
            container_port = var.configuser_https_port
            protocol       = "TCP"
          }

          port {
            name           = "7778-tcp"
            container_port = var.configuser_websocket_port
            protocol       = "TCP"
          }

          volume_mount {
            name       = "nem-data"
            mount_path = var.configuser_nem_folder
          }

          dynamic "volume_mount" {
            for_each = local.volume_config_items

            content {
              name       = "config"
              mount_path = volume_mount.value.mount_path
              sub_path   = volume_mount.value.path
            }
          }

          dynamic "liveness_probe" {
            for_each = var.liveness_probe_enabled ? [1] : []

            content {
              tcp_socket {
                port = "http"
              }

              initial_delay_seconds = var.liveness_probe_initial_delay
              period_seconds        = var.liveness_probe_period
            }
          }

          dynamic "readiness_probe" {
            for_each = var.readiness_probe_enabled ? [1] : []
            content {
              tcp_socket {
                port = "http"
              }

              initial_delay_seconds = var.readiness_probe_initial_delay
              period_seconds        = var.readiness_probe_period
            }
          }

          image_pull_policy = var.image_pull_policy
        }

        termination_grace_period_seconds = var.termination_grace_period

        security_context {
          run_as_user  = var.pod_security_context.runAsUser
          run_as_group = var.pod_security_context.runAsGroup
        }
      }
    }

    dynamic "volume_claim_template" {
      for_each = var.persistence_enabled ? [1] : []
      content {
        metadata {
          name = "nem-data"
        }

        spec {
          access_modes = var.persistence_access_modes

          resources {
            requests = {
              storage = var.persistence_storage_size
            }
          }

          storage_class_name = var.persistence_storage_class_name
        }
      }
    }

    service_name          = "${local.full_name}-headless"
    pod_management_policy = var.pod_management_policy

    update_strategy {
      type = var.update_strategy
    }
  }
}
