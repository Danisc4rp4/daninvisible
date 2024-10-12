# Give the permission needed for the Githubactions SA to be able to apply infra changes.

data "google_service_account" "githubactions" {
  account_id = var.githubactions_sa
}

resource "google_project_iam_custom_role" "githubactions-custom" {
  project = var.project_id
  role_id = "githubactions_custom"
  title   = "Githubactions Custom"

  permissions = [
    "artifactregistry.repositories.downloadArtifacts",
    "artifactregistry.repositories.uploadArtifacts",
    "compute.instanceGroupManagers.get",
    "compute.instanceGroupManagers.update",
    "compute.networks.create",
    "compute.networks.get",
    "compute.subnetworks.get",
    "compute.subnetworks.create",
    "container.clusters.get",
    "container.clusters.create",
    "container.clusters.update",
    "container.clusters.delete",
    "container.configMaps.create",
    "container.configMaps.delete",
    "container.configMaps.get",
    "container.configMaps.list",
    "container.configMaps.update",
    "container.cronJobs.create",
    "container.cronJobs.delete",
    "container.cronJobs.get",
    "container.cronJobs.update",
    "container.customResourceDefinitions.create",
    "container.customResourceDefinitions.delete",
    "container.customResourceDefinitions.get",
    "container.customResourceDefinitions.list",
    "container.customResourceDefinitions.update",
    "container.deployments.create",
    "container.deployments.delete",
    "container.deployments.get",
    "container.deployments.update",
    "container.ingresses.create",
    "container.ingresses.delete",
    "container.ingresses.get",
    "container.ingresses.update",
    "container.jobs.create",
    "container.jobs.delete",
    "container.jobs.get",
    "container.jobs.update",
    "container.namespaces.get",
    "container.namespaces.list",
    "container.namespaces.create",
    "container.namespaces.update",
    "container.operations.get",
    "container.persistentVolumeClaims.create",
    "container.persistentVolumeClaims.delete",
    "container.persistentVolumeClaims.get",
    "container.persistentVolumeClaims.update",
    "container.pods.create",
    "container.pods.delete",
    "container.pods.get",
    "container.pods.list",
    "container.pods.update",
    "container.resourceQuotas.create",
    "container.resourceQuotas.update",
    "container.clusterRoles.update",
    "container.clusterRoleBindings.update",
    "container.roleBindings.create",
    "container.roleBindings.delete",
    "container.roleBindings.get",
    "container.roleBindings.update",
    "container.roles.create",
    "container.roles.delete",
    "container.roles.escalate",
    "container.roles.get",
    "container.roles.update",
    "container.secrets.create",
    "container.secrets.delete",
    "container.secrets.get",
    "container.secrets.list",
    "container.secrets.update",
    "container.serviceAccounts.create",
    "container.serviceAccounts.delete",
    "container.serviceAccounts.get",
    "container.serviceAccounts.update",
    "container.services.create",
    "container.services.delete",
    "container.services.get",
    "container.services.list",
    "container.services.update",
    "container.statefulSets.create",
    "container.statefulSets.delete",
    "container.statefulSets.get",
    "container.statefulSets.list",
    "container.statefulSets.update",
    "container.thirdPartyObjects.create",
    "container.thirdPartyObjects.delete",
    "container.thirdPartyObjects.get",
    "container.thirdPartyObjects.list",
    "container.thirdPartyObjects.update",
    "dns.changes.create",
    "dns.changes.get",
    "dns.resourceRecordSets.get",
    "dns.resourceRecordSets.list",
    "dns.resourceRecordSets.update",
    "iam.serviceAccounts.create",
    "iam.serviceAccounts.update",
    "iam.serviceAccounts.delete",
    "storage.buckets.get",
    "storage.objects.create",
    "storage.objects.delete",
    "storage.objects.get",
    "storage.objects.list",
  ]
}

resource "google_project_iam_member" "githubactions" {
  project = var.project_id
  role    = google_project_iam_custom_role.githubactions-custom.name
  member  = "serviceAccount:${data.google_service_account.githubactions.email}"

  depends_on = [google_project_iam_custom_role.githubactions-custom]
}

resource "google_project_iam_member" "githubactions_containeradmin" {
  project = var.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${data.google_service_account.githubactions.email}"

  depends_on = [google_project_iam_custom_role.githubactions-custom]
}

resource "google_project_iam_member" "githubactions_artifact_registry_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${data.google_service_account.githubactions.email}"

  depends_on = [google_project_iam_custom_role.githubactions-custom]
}

resource "google_project_iam_member" "githubactions_service_account_token_create" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${data.google_service_account.githubactions.email}"

  depends_on = [google_project_iam_custom_role.githubactions-custom]
}


