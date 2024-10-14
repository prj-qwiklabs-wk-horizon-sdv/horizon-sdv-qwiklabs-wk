
resource "google_secret_manager_secret" "sdv_secret" {
  secret_id = "sdv-secret"


  replication {
    user_managed {
      replicas {
        location = var.location
      }
    }
  }
}

resource "google_secret_manager_secret_version" "sdv_secret_version" {
  secret      = google_secret_manager_secret.sdv_secret.id
  secret_data = var.sdv_secret
}