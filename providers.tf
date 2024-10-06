provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_client_config" "default" {}

provider "kubernetes" {
    host                   = "https://${google_container_cluster.default.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.default.master_auth[0].cluster_ca_certificate)

    ignore_annotations = [
      "^autopilot\\.gke\\.io\\/.*",
      "^cloud\\.google\\.com\\/.*"
    ]
}

provider "flux" {
  kubernetes = {
    host                   = "https://${google_container_cluster.default.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.default.master_auth[0].cluster_ca_certificate)

    ignore_annotations = [
      "^autopilot\\.gke\\.io\\/.*",
      "^cloud\\.google\\.com\\/.*"
    ]
  }
  git = {
    url = "ssh://git@github.com/${var.github_org}/${var.github_repository}.git"
    ssh = {
      username    = "git"
      private_key = tls_private_key.flux.private_key_pem
    }
  }
}

provider "github" {
  owner = var.github_org
  token = var.github_token
}


terraform {
  backend "gcs" {
    bucket = "GOOGLE_PROJECT_ID-tfstate"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
      version = ">= 4.0.0"
    }
    flux = {
      source = "fluxcd/flux"
      version = "1.4.0"
    }
    github = {
      source  = "integrations/github"
      version = ">= 6.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }
  }
} 
