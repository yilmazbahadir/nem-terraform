resource "kubernetes_config_map" "configmap" {
  metadata {
    name      = local.full_name
    labels    = local.labels
    namespace = var.namespace
  }

  data = {
    "configuser.properties"        = "${local.configuser_properties_content}"
    "logalpha.properties"          = "${var.logalpha_properties}"
    "db.properties"                = "${var.db_properties}"
    "${local.peers_json_filename}" = "${var.peers_config_json}"
  }

  binary_data = {
    nemesis-file = "${var.nemesis_file_base64}"
  }
}
