
variable "tf_state_bucket" {
  type = string
}

variable "infra_bucket" {
  type = string
}

variable "github_token" {
  description = "GitHub token"
  sensitive   = true
  type        = string
  default     = ""
}

variable "github_org" {
  description = "GitHub organization"
  type        = string
  default     = ""
}

variable "github_repository" {
  description = "GitHub repository"
  type        = string
  default     = ""
}


variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "Region to deploy GCP resources"
  type        = string
  default     = "us-central1"
}

variable "gke_cluster_name" {
  description = "Name of the GKE cluster."
  type        = string
}

variable "primary_ip_cidr" {
  description = "Primary CIDR for nodes.  /24 will provide 256 node addresses."
  type        = string
  default     = "10.0.0.0/16"
}

variable "services_ip_cidr" {
  description = "Primary CIDR for nodes.  /24 will provide 256 node addresses."
  type        = string
  default     = "192.168.0.0/24"
}

variable "pods_ip_cidr" {
  description = "Primary CIDR for nodes.  /24 will provide 256 node addresses."
  type        = string
  default     = "192.168.1.0/24"
}

variable "githubactions_sa" {
  description = "Githubaction SA."
  type        = string
}

variable "deploy_flux" {
  description = "Wether to deploy flux or not"
  type        = bool
  default     = false
}

