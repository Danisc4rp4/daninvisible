provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  backend "gcs" {
    bucket = "GOOGLE_PROJECT_ID-tfstate"
    prefix = "terraform/state"
  }
} 