# Configure Kubernetes provider and connect to the Kubernetes API server
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop"
}
