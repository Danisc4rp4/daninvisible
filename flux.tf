# ==========================================
# Initialise a Github project
# ==========================================

resource "github_repository" "this" {
  name        = var.github_repository
  description = var.github_repository
  visibility  = "public"
  auto_init   = true # This is extremely important as flux_bootstrap_git will not work without a repository that has been initialised
}

# ==========================================
# Add deploy key to GitHub repository
# ==========================================

resource "tls_private_key" "flux" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "github_repository_deploy_key" "this" {
  title      = "Flux"
  repository = github_repository.this.name
  key        = tls_private_key.flux.public_key_openssh
  read_only  = "false"
}

# ==========================================
# Bootstrap cluster
# ==========================================

resource "flux_bootstrap_git" "this" {
  embedded_manifests = true
  path               = "clusters/cicd"

  depends_on = [github_repository_deploy_key.this, google_container_cluster.default]
}

# data "github_repository_file" "config" {
#   repository          = var.github_repository
#   branch              = "master"
#   file                = "config-fil"
# }
