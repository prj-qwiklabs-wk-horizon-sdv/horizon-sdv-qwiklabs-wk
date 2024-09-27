
resource "google_project_service" "service" {
  for_each = toset([
    "container.googleapis.com",
    "iap.googleapis.com",
    "certificatemanager.googleapis.com",
    "integrations.googleapis.com",
  ])

  service = each.key

  project            = var.project
  disable_on_destroy = false
}
