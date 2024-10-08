# ==========================================
# Initialise a Github project
# ==========================================

resource "github_repository" "this" {
  count       = var.deploy_flux ? 1 : 0
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
  count       = var.deploy_flux ? 1 : 0
  title      = "Flux"
  repository = github_repository.this[0].name
  key        = tls_private_key.flux[0].public_key_openssh
  read_only  = "false"
}

# ==========================================
# Bootstrap cluster
# ==========================================

resource "flux_bootstrap_git" "this" {
  count       = var.deploy_flux ? 1 : 0
  embedded_manifests = true
  path               = "clusters/cicd"

  depends_on = [github_repository_deploy_key.this, google_container_cluster.default]
}
