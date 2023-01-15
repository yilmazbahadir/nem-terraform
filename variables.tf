variable "name" {
  type        = string
  description = "Name of the application"
  default     = "nem-client"
}

variable "deploy_name" {
  type        = string
  description = "(Required) Name of the deployment"
}


variable "namespace" {
  type        = string
  description = "(Optional) Namespace in which to create the resources"
  default     = "default"
}

variable "image_repository" {
  description = "(Optional) Docker image repository"
  type        = string
  default     = "nemofficial/nis-client"
}

variable "image_tag" {
  description = "(Optional) Docker image tag"
  type        = string
  default     = "0.6.100@sha256:8ccfdb5de8cfce01c91c599fe2c91ddafe74940923e3d1bda667137747dd7dcd"
}
variable "image_pull_policy" {
  description = "(Optional) Docker image pull policy"
  type        = string
  default     = "IfNotPresent"
}

variable "deployment_annotations" {
  description = "Annotations for deployment"
  type        = map(string)
  default     = null
}

variable "configuser_properties" {
  type        = string
  description = "config-user.properties file content"
}

variable "logalpha_properties" {
  type        = string
  description = "(Optional) logalpha.properties file content"
  default     = ""
}

variable "peers_config_json" {
  type        = string
  description = "(Optional) peers-config-{network}.json file content"
  default     = ""
}

variable "db_properties" {
  type        = string
  description = "(Optional) db.properties file content"
  default     = ""
}

variable "nemesis_file_base64" {
  description = "(Optional) Base64 encoded nemesis file content"
  type        = string
  default     = ""
}

variable "network" {
  description = "(Optional) NEM network(mainnet|testnet)"
  type        = string
  default     = "mainnet"
}

variable "custom_labels" {
  description = "(Optional) Custom labels for the resources"
  type        = map(string)
  default     = null
}

variable "annotations" {
  description = "(Optional) Annotations for the StatefulSet"
  type        = map(string)
  default     = {}
}

variable "pod_management_policy" {
  description = "(Optional) Pod management policy"
  type        = string
  default     = "OrderedReady"
}

variable "update_strategy" {
  description = "(Optional) Type of deployment. Can be 'Recreate' or 'RollingUpdate'"
  type        = string
  default     = "RollingUpdate"
}
