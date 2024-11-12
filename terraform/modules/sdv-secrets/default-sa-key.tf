data "google_project" "project" {}

resource "google_service_account_key" "sa_key" {
  service_account_id = "268541173342-compute@developer.gserviceaccount.com"
  private_key_type   = "TYPE_GOOGLE_CREDENTIALS_FILE"
}

resource "google_secret_manager_secret" "sa_key_secret" {
  secret_id = "gce-creds"

  replication {
    user_managed {
      replicas {
        location = var.location
      }
    }
  }
}

resource "google_secret_manager_secret_version" "sa_key_secret_version" {
  secret      = google_secret_manager_secret.sa_key_secret.id
  secret_data = base64decode(google_service_account_key.sa_key.private_key)
}
