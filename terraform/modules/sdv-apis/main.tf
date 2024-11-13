
data "google_project" "project" {}

resource "google_project_service" "service" {
  for_each = var.list_of_apis

  service            = each.key
  project            = data.google_project.project.project_id
  disable_on_destroy = false
}
