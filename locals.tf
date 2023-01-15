locals {
  full_name = "${var.name}-${var.deploy_name}"
  labels = var.custom_labels == null ? { "app.kubernetes.io/instance" = var.deploy_name
  "app.kubernetes.io/name" = var.name } : var.custom_labels
  peers_json_filename = "peers-config_${var.network}.json"
  image_name          = "${var.image_repository}:${var.image_tag}"
}
