
resource "google_project_service" "container_googleapis" {
  project = var.project
  service = "container.googleapis.com"
}

resource "google_project_service" "iap_googleapis" {
  project = var.project
  service = "iap.googleapis.com"
}

resource "google_project_service" "certificatemanager_googleapis" {
  project = var.project
  service = "certificatemanager.googleapis.com"
}

resource "google_project_service" "integrations_googleapis" {
  project = var.project
  service = "integrations.googleapis.com"
}

