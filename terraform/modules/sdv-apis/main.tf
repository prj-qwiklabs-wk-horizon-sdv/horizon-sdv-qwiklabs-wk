
data "google_project" "project" {}

resource "google_project_service" "service" {
  for_each = toset([
    "container.googleapis.com",
    "iap.googleapis.com",
    "certificatemanager.googleapis.com",
    "integrations.googleapis.com",
    "secretmanager.googleapis.com",
    "file.googleapis.com",
  ])

  service            = each.key
  project            = data.google_project.project.project_id
  disable_on_destroy = false
}
