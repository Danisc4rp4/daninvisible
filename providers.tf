provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  backend "gcs" {
    bucket = "GOOGLE_PROJECT_ID-tfstate"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.6.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "1.4.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.3.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }
  }
}
