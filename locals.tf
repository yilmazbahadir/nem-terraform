locals {
  full_name = "${var.name}-${var.deploy_name}"
  labels = var.custom_labels == null ? { "app.kubernetes.io/instance" = var.deploy_name
  "app.kubernetes.io/name" = var.name } : var.custom_labels
  peers_json_filename = "peers-config_${var.configuser_nem_network}.json"
  image_name          = "${var.image_repository}:${var.image_tag}"
  configuser_properties_content = join("\n", [for key, value in merge(var.configuser_extra_map, {
    "nem.folder"                  = var.configuser_nem_folder
    "nem.network"                 = var.configuser_nem_network
    "nem.httpPort"                = var.configuser_http_port
    "nem.httpsPort"               = var.configuser_https_port
    "nem.websocketPort"           = var.configuser_websocket_port
    "nem.host"                    = var.configuser_nem_host
    "nem.network.nemesisFilePath" = var.configuser_nemesis_file_path
    "nis.bootKey"                 = var.configuser_nis_boot_key
    "nis.bootName"                = var.configuser_nis_boot_name
  }) : "${key}=${value}" if value != ""])
}
