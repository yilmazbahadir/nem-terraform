variable "configuser_properties" {
    type = string
    description = "config-user.properties file content"
}

variable "logalpha_properties" {
    type = string
    description = "logalpha.properties file content"
    default = ""
}

variable "db_properties" {
    type = string
    description = "db.properties file content"
    default = ""
}

variable "nemesis_file_base64" {
    type = string
    description = "base64 encoded nemesis file content"
    default = ""
}
