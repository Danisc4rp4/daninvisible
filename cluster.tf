resource "google_compute_network" "default" {
  name = "cicd-network"

  auto_create_subnetworks  = false
  enable_ula_internal_ipv6 = true

  depends_on = [google_project_iam_member.githubactions]
}

resource "google_compute_subnetwork" "default" {
  name = "cicd-subnetwork"

  ip_cidr_range = var.primary_ip_cidr
  region        = var.region

  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "INTERNAL" # Change to "EXTERNAL" if creating an external loadbalancer

  network = google_compute_network.default.id
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = var.services_ip_cidr
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = var.pods_ip_cidr
  }

  depends_on = [google_compute_network.default]
}

resource "google_container_cluster" "default" {
  name     = var.gke_cluster_name
  location = var.zone

  enable_l4_ilb_subsetting = true
  remove_default_node_pool = true

  initial_node_count = 1

  network    = google_compute_network.default.id
  subnetwork = google_compute_subnetwork.default.id

  ip_allocation_policy {
    services_secondary_range_name = google_compute_subnetwork.default.secondary_ip_range[0].range_name
    cluster_secondary_range_name  = google_compute_subnetwork.default.secondary_ip_range[1].range_name
  }

  deletion_protection = true

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = false             # To be enabled after building and replacing images
    # master_ipv4_cidr_block  = "10.100.100.0/28" # if enable_private_endpoint = true
  }

  depends_on = [
    google_compute_subnetwork.default,
  ]
}

resource "google_service_account" "default" {
  account_id   = "gke-nodepool"
  display_name = "Service Account for GKE Nodepools"
}

resource "google_project_iam_member" "gke-nodepools-artifactregistry-read" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.default.email}"

  depends_on = [google_service_account.default]
}

resource "google_container_node_pool" "system" {
  name       = "system"
  cluster    = google_container_cluster.default.id
  node_count = 1

  node_locations = [
    var.zone,
  ]

  node_config {
    preemptible  = true
    machine_type = "e2-standard-4"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }
}
