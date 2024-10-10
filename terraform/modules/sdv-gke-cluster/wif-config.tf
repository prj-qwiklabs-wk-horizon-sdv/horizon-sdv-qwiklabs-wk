
resource "google_iam_workload_identity_pool" "pool" {
  workload_identity_pool_id = "sdv-wif-pool"
  display_name              = "SDV Identity Pool"
  description               = "A WIF pool for SDV cluster"
}

resource "google_iam_workload_identity_pool_provider" "provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "wip-provider"
  display_name                       = "OIDC Provider"
  description                        = "A WIP provider for SDV cluster"

  oidc {
    issuer_uri = "https://container.googleapis.com/v1/projects/${data.google_project.project.project_id}/locations/${var.location}/clusters/${var.cluster_name}"
  }

  attribute_mapping = {
    "google.subject" = "assertion.sub"
    "attribute.aud"  = "assertion.aud"
  }
}

resource "google_service_account" "sa" {
  project      = data.google_project.project.project_id
  account_id   = "sdv-wif-sa"
  display_name = "SDV SA for WIF"
}

resource "google_service_account_iam_member" "binding" {
  service_account_id = google_service_account.sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.pool.name}/attribute.aud/${var.cluster_name}"
}

resource "google_project_iam_member" "artifact_registry" {
  project = data.google_project.project.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_project_iam_member" "storage" {
  project = data.google_project.project.project_id
  role    = "roles/storage.objectUser"
  member  = "serviceAccount:${google_service_account.sa.email}"
}

#
# TODO: this on the kubernetes
#
# resource "kubernetes_service_account" "ksa" {
#   metadata {
#     name      = "sdv-wif-kubernetes-sa"
#     namespace = "default"
#     annotations = {
#       "iam.gke.io/gcp-service-account" = google_service_account.sa.email
#     }
#   }
# }
