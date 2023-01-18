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

variable "configuser_nem_folder" {
  description = "Folder database and log files should be located"
  type        = string
  default     = "/app/data"
}

variable "configuser_nem_network" {
  description = "(Optional) NEM network(mainnet|testnet)"
  type        = string
  default     = "mainnet"
}

variable "configuser_http_port" {
  description = "(Optional) Http port"
  type        = number
  default     = 7890
}

variable "configuser_https_port" {
  description = "(Optional) Https port"
  type        = number
  default     = 7891
}

variable "configuser_websocket_port" {
  description = "(Optional) Websocket port"
  type        = number
  default     = 7778
}

variable "configuser_nem_host" {
  description = "(Optional) hostname/ip e.g. example.com"
  type        = string
  default     = "127.0.0.1"
}

variable "configuser_nemesis_file_path" {
  description = "(Optional) nemesis.bin file path, leave empty when no custom nemesis files, set to /usersettings/nemesis.bin otherwise"
  type        = string
  default     = ""
}

variable "configuser_nis_boot_key" {
  description = "(Optional) If not set new account will be generated and set"
  type        = string
  default     = ""
}

variable "configuser_nis_boot_name" {
  description = "(Optional) friendly name of the NIS node"
  type        = string
  default     = ""
}

variable "configuser_extra_map" {
  description = "(Optional) Extra key value pairs for configuser.properties"
  type        = map(string)
  default     = null
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

variable "init_chown_data" {
  description = "(Optional) Init container details to change file ownership"
  type = object({
    enabled = bool
    image = object({
      repository  = string
      tag         = string
      pull_policy = string
    })
  })
  default = {
    enabled = true
    image = {
      repository  = "busybox"
      tag         = "1.35.0"
      pull_policy = "IfNotPresent"
    }
  }
}

variable "pod_security_context" {
  description = "(Optional) User id"
  type = object({
    runAsUser  = number
    runAsGroup = number
  })
  default = {
    runAsUser  = 11001
    runAsGroup = 11001
  }
}

variable "liveness_probe_enabled" {
  description = "(Optional) Enable liveness probe for statefulset"
  type        = bool
  default     = true
}

variable "liveness_probe_initial_delay" {
  description = "(Optional) Liveness probe initial delay seconds"
  type        = number
  default     = 60
}

variable "liveness_probe_period" {
  description = "(Optional) Liveness probe period seconds"
  type        = number
  default     = 120
}

variable "readiness_probe_enabled" {
  description = "(Optional) Enable readiness probe for statefulset"
  type        = bool
  default     = true
}

variable "readiness_probe_initial_delay" {
  description = "(Optional) Readiness probe initial delay seconds"
  type        = number
  default     = 60
}

variable "readiness_probe_period" {
  description = "(Optional) Readiness probe period seconds"
  type        = number
  default     = 120
}

variable "termination_grace_period" {
  description = "(Optional) The application is given a certain amount of time(seconds) to shutdown before it's terminated forcefully"
  type        = number
  default     = 300
}

variable "persistence_enabled" {
  description = "(Optional) Persistent storage is enabled (if disabled storage type will be EmptyDir)"
  type        = bool
  default     = true
}

variable "persistence_storage_class_name" {
  description = "(Optional) Persistent storage class name e.g: local-path"
  type        = string
  default     = "local-path"
}

variable "persistence_storage_size" {
  description = "(Optional) Persistent storage size e.g: 8Gi"
  type        = string
  default     = "8Gi"
}

variable "persistence_access_modes" {
  description = "(Optional) Persistent storage access modes"
  type        = list(string)
  default     = ["ReadWriteOnce"]
}

variable "ingress_enabled" {
  description = "(Optional) Ingress enabled"
  type        = bool
  default     = true
}

variable "ingress_class_name" {
  description = "(Optional) Ingress class name"
  type        = string
  default     = "nginx"
}

variable "ingress_annotations" {
  description = "(Optional) Ingress annotations"
  type        = list(any)
  default     = []
}

variable "ingress_rules" {
  description = "(Optional) Ingress rules and paths"
  #   type        = list(any)
  type = list(object({
    host = string
    paths = list(object({
      path                 = string
      path_type            = string
      backend_service_port = number
    }))
  }))
  default = [{
    host = "localhost"
    paths = [
      {
        path                 = "/"
        path_type            = "ImplementationSpecific"
        backend_service_port = 7890
      },
      {
        path                 = "/"
        path_type            = "ImplementationSpecific"
        backend_service_port = 7891
      },
      {
        path                 = "/"
        path_type            = "ImplementationSpecific"
        backend_service_port = 7778
      }
    ]
  }]
}
