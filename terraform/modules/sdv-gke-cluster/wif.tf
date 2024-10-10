
# data "google_project" "project" {}

resource "google_iam_workload_identity_pool" "sdv_wi_pool" {
  workload_identity_pool_id = "sdv-wi-pool"
  display_name              = "SDV Workload Identity Pool"
  description               = "A WIF pool for SDV cluster"
}


resource "google_service_account" "gke_jenkis_sa" {
  account_id   = "gke-jenkis-sa"
  display_name = "jenkis SA"
  description  = "the deployment of Jenkis in GKE cluster makes use of this account through WIF"
}


resource "google_service_account_iam_binding" "gke_jenkis_sa_wi_users" {
  service_account_id = google_service_account.gke_jenkis_sa.id

  role = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${data.google_project.project.project_id}.svc.id.goog[jenkis/jenkis-sa]",
  ]

  depends_on = [
    google_service_account.gke_jenkis_sa
  ]
}

resource "google_project_iam_binding" "gke_jenkis_sa_iam" {
  project = data.google_project.project.id

  role = "roles/storage.objectUser"

  members = [
    "serviceAccount:${google_service_account.gke_jenkis_sa.email}",
  ]

  depends_on = [
    google_service_account.gke_jenkis_sa
  ]
}
