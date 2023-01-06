resource "kubernetes_config_map" "configmap" {
    metadata {
        name = "configmap"
    }

    data = {
        "configuser.properties" = "${var.configuser_properties}"
        "logalpha.properties" = "${var.logalpha_properties}"
        "db.properties" = "${var.db_properties}"
    }

    binary_data = {
        nemesis-file = "${var.nemesis_file_base64}"
    }
}