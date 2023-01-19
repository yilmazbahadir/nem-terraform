# nem-terraform
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.16.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_config_map.configmap](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_ingress_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_service.headless](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_service.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [kubernetes_stateful_set.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/stateful_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_annotations"></a> [annotations](#input\_annotations) | (Optional) Annotations for the StatefulSet | `map(string)` | `{}` | no |
| <a name="input_configuser_extra_map"></a> [configuser\_extra\_map](#input\_configuser\_extra\_map) | (Optional) Extra key value pairs for configuser.properties | `map(string)` | `null` | no |
| <a name="input_configuser_http_port"></a> [configuser\_http\_port](#input\_configuser\_http\_port) | (Optional) Http port | `number` | `7890` | no |
| <a name="input_configuser_https_port"></a> [configuser\_https\_port](#input\_configuser\_https\_port) | (Optional) Https port | `number` | `7891` | no |
| <a name="input_configuser_nem_folder"></a> [configuser\_nem\_folder](#input\_configuser\_nem\_folder) | Folder database and log files should be located | `string` | `"/app/data"` | no |
| <a name="input_configuser_nem_host"></a> [configuser\_nem\_host](#input\_configuser\_nem\_host) | (Optional) hostname/ip e.g. example.com | `string` | `"127.0.0.1"` | no |
| <a name="input_configuser_nem_network"></a> [configuser\_nem\_network](#input\_configuser\_nem\_network) | (Optional) NEM network(mainnet\|testnet) | `string` | `"mainnet"` | no |
| <a name="input_configuser_nemesis_file_path"></a> [configuser\_nemesis\_file\_path](#input\_configuser\_nemesis\_file\_path) | (Optional) nemesis.bin file path, leave empty when no custom nemesis files, set to /usersettings/nemesis.bin otherwise | `string` | `""` | no |
| <a name="input_configuser_nis_boot_key"></a> [configuser\_nis\_boot\_key](#input\_configuser\_nis\_boot\_key) | (Optional) If not set new account will be generated and set | `string` | `""` | no |
| <a name="input_configuser_nis_boot_name"></a> [configuser\_nis\_boot\_name](#input\_configuser\_nis\_boot\_name) | (Optional) friendly name of the NIS node | `string` | `""` | no |
| <a name="input_configuser_websocket_port"></a> [configuser\_websocket\_port](#input\_configuser\_websocket\_port) | (Optional) Websocket port | `number` | `7778` | no |
| <a name="input_custom_labels"></a> [custom\_labels](#input\_custom\_labels) | (Optional) Custom labels for the resources | `map(string)` | `null` | no |
| <a name="input_db_properties"></a> [db\_properties](#input\_db\_properties) | (Optional) db.properties file content | `string` | `""` | no |
| <a name="input_deploy_name"></a> [deploy\_name](#input\_deploy\_name) | (Required) Name of the deployment | `string` | n/a | yes |
| <a name="input_deployment_annotations"></a> [deployment\_annotations](#input\_deployment\_annotations) | Annotations for deployment | `map(string)` | `null` | no |
| <a name="input_image_pull_policy"></a> [image\_pull\_policy](#input\_image\_pull\_policy) | (Optional) Docker image pull policy | `string` | `"IfNotPresent"` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | (Optional) Docker image repository | `string` | `"nemofficial/nis-client"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | (Optional) Docker image tag | `string` | `"0.6.100@sha256:8ccfdb5de8cfce01c91c599fe2c91ddafe74940923e3d1bda667137747dd7dcd"` | no |
| <a name="input_ingress_annotations"></a> [ingress\_annotations](#input\_ingress\_annotations) | (Optional) Ingress annotations | `list(any)` | `[]` | no |
| <a name="input_ingress_class_name"></a> [ingress\_class\_name](#input\_ingress\_class\_name) | (Optional) Ingress class name | `string` | `"nginx"` | no |
| <a name="input_ingress_enabled"></a> [ingress\_enabled](#input\_ingress\_enabled) | (Optional) Ingress enabled | `bool` | `false` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | (Optional) Ingress rules and paths | <pre>list(object({<br>    host = string<br>    paths = list(object({<br>      path                 = string<br>      path_type            = string<br>      backend_service_port = number<br>    }))<br>  }))</pre> | <pre>[<br>  {<br>    "host": "localhost",<br>    "paths": [<br>      {<br>        "backend_service_port": 7890,<br>        "path": "/",<br>        "path_type": "ImplementationSpecific"<br>      },<br>      {<br>        "backend_service_port": 7891,<br>        "path": "/",<br>        "path_type": "ImplementationSpecific"<br>      },<br>      {<br>        "backend_service_port": 7778,<br>        "path": "/",<br>        "path_type": "ImplementationSpecific"<br>      }<br>    ]<br>  }<br>]</pre> | no |
| <a name="input_ingress_tls"></a> [ingress\_tls](#input\_ingress\_tls) | Ingress TLS parameters | `list(any)` | `[]` | no |
| <a name="input_init_chown_data"></a> [init\_chown\_data](#input\_init\_chown\_data) | (Optional) Init container details to change file ownership | <pre>object({<br>    enabled = bool<br>    image = object({<br>      repository  = string<br>      tag         = string<br>      pull_policy = string<br>    })<br>  })</pre> | <pre>{<br>  "enabled": true,<br>  "image": {<br>    "pull_policy": "IfNotPresent",<br>    "repository": "busybox",<br>    "tag": "1.35.0"<br>  }<br>}</pre> | no |
| <a name="input_liveness_probe_enabled"></a> [liveness\_probe\_enabled](#input\_liveness\_probe\_enabled) | (Optional) Enable liveness probe for statefulset | `bool` | `true` | no |
| <a name="input_liveness_probe_initial_delay"></a> [liveness\_probe\_initial\_delay](#input\_liveness\_probe\_initial\_delay) | (Optional) Liveness probe initial delay seconds | `number` | `60` | no |
| <a name="input_liveness_probe_period"></a> [liveness\_probe\_period](#input\_liveness\_probe\_period) | (Optional) Liveness probe period seconds | `number` | `120` | no |
| <a name="input_logalpha_properties"></a> [logalpha\_properties](#input\_logalpha\_properties) | (Optional) logalpha.properties file content | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the application | `string` | `"nem-client"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | (Optional) Namespace in which to create the resources | `string` | `"default"` | no |
| <a name="input_nemesis_file_base64"></a> [nemesis\_file\_base64](#input\_nemesis\_file\_base64) | (Optional) Base64 encoded nemesis file content | `string` | `""` | no |
| <a name="input_peers_config_json"></a> [peers\_config\_json](#input\_peers\_config\_json) | (Optional) peers-config-{network}.json file content | `string` | `""` | no |
| <a name="input_persistence_access_modes"></a> [persistence\_access\_modes](#input\_persistence\_access\_modes) | (Optional) Persistent storage access modes | `list(string)` | <pre>[<br>  "ReadWriteOnce"<br>]</pre> | no |
| <a name="input_persistence_enabled"></a> [persistence\_enabled](#input\_persistence\_enabled) | (Optional) Persistent storage is enabled (if disabled storage type will be EmptyDir) | `bool` | `true` | no |
| <a name="input_persistence_storage_class_name"></a> [persistence\_storage\_class\_name](#input\_persistence\_storage\_class\_name) | (Optional) Persistent storage class name e.g: local-path | `string` | `"local-path"` | no |
| <a name="input_persistence_storage_size"></a> [persistence\_storage\_size](#input\_persistence\_storage\_size) | (Optional) Persistent storage size e.g: 8Gi | `string` | `"8Gi"` | no |
| <a name="input_pod_management_policy"></a> [pod\_management\_policy](#input\_pod\_management\_policy) | (Optional) Pod management policy | `string` | `"OrderedReady"` | no |
| <a name="input_pod_security_context"></a> [pod\_security\_context](#input\_pod\_security\_context) | (Optional) User id | <pre>object({<br>    runAsUser  = number<br>    runAsGroup = number<br>  })</pre> | <pre>{<br>  "runAsGroup": 11001,<br>  "runAsUser": 11001<br>}</pre> | no |
| <a name="input_readiness_probe_enabled"></a> [readiness\_probe\_enabled](#input\_readiness\_probe\_enabled) | (Optional) Enable readiness probe for statefulset | `bool` | `true` | no |
| <a name="input_readiness_probe_initial_delay"></a> [readiness\_probe\_initial\_delay](#input\_readiness\_probe\_initial\_delay) | (Optional) Readiness probe initial delay seconds | `number` | `60` | no |
| <a name="input_readiness_probe_period"></a> [readiness\_probe\_period](#input\_readiness\_probe\_period) | (Optional) Readiness probe period seconds | `number` | `120` | no |
| <a name="input_termination_grace_period"></a> [termination\_grace\_period](#input\_termination\_grace\_period) | (Optional) The application is given a certain amount of time(seconds) to shutdown before it's terminated forcefully | `number` | `300` | no |
| <a name="input_update_strategy"></a> [update\_strategy](#input\_update\_strategy) | (Optional) Type of deployment. Can be 'Recreate' or 'RollingUpdate' | `string` | `"RollingUpdate"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->