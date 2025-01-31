data "google_client_config" "default" {
  depends_on = [google_container_cluster.default]
}

provider "flux" {
  kubernetes = {
    host                   = "https://${google_container_cluster.default.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.default.master_auth[0].cluster_ca_certificate)
    config_context         = "gke_${var.project_id}_${var.zone}_${var.gke_cluster_name}"
    load_config_file       = false
  }
  git = {
    url = "ssh://git@github.com/${var.github_org}/${var.github_repository}.git"
    ssh = {
      username    = "git"
      private_key = length(tls_private_key.flux) > 0 ? tls_private_key.flux[0].private_key_pem : ""
    }
  }
}

provider "github" {
  owner = var.github_org
  token = var.github_token
}

# ==========================================
# Initialise a Github project
# ==========================================

data "github_repository" "this" {
  count = !var.deploy_flux || var.create_flux_repo ? 0 : 1
  name  = var.github_repository
}


resource "github_repository" "this" {
  count       = var.create_flux_repo ? 1 : 0
  name        = var.github_repository
  description = var.github_repository
  visibility  = "public"
  auto_init   = true # This is extremely important as flux_bootstrap_git will not work without a repository that has been initialised
}

# ==========================================
# Add deploy key to GitHub repository
# ==========================================

resource "tls_private_key" "flux" {
  count       = var.deploy_flux ? 1 : 0
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "github_repository_deploy_key" "this" {
  count      = var.deploy_flux ? 1 : 0
  title      = "Flux"
  repository = var.create_flux_repo ? github_repository.this[0].name : data.github_repository.this[0].name
  key        = tls_private_key.flux[0].public_key_openssh
  read_only  = "false"

  depends_on = [
    github_repository.this,
    tls_private_key.flux,
  ]
}

# ==========================================
# Bootstrap cluster
# ==========================================

resource "flux_bootstrap_git" "this" {
  count              = var.deploy_flux ? 1 : 0
  embedded_manifests = true
  path               = "clusters/cicd"

  depends_on = [google_container_node_pool.system]
}
