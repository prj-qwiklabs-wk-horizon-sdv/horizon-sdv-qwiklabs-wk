
resource "google_project_service" "project" {
  project = var.project
  service = "container.googleapis.com"
}

resource "google_project_service" "project_service" {
  project = var.project
  service = "iap.googleapis.com"
}

resource "google_project_service" "certificate_manager_api" {
  project = var.project
  service = "certificatemanager.googleapis.com"
}

resource "google_project_service" "integrations_googleapis" {
  project = var.project
  service = "integrations.googleapis.com"
}

