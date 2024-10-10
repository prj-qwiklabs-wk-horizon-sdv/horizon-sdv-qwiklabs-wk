
data "google_project" "project" {}

resource "google_storage_bucket" "bucket" {
  name                        = "${data.google_project.project.project_id}-aaos"
  location                    = var.location
  uniform_bucket_level_access = true
}
