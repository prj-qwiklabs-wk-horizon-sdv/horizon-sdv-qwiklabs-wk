resource "google_project_service" "project" {
  project = var.project_id
  service = "container.googleapis.com"
}

resource "google_project_service" "project_service" {
  project = var.project_id
  service = "iap.googleapis.com"
}
