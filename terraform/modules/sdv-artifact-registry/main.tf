
data "google_project" "project" {}

resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.location
  repository_id = var.repository_id
  format        = "DOCKER"
  description   = "Docker repository for Horizon SDV Dev"
}

resource "google_project_iam_member" "artifact_registry_writer" {
  for_each = toset(var.members)

  project = data.google_project.project.project_id
  role    = "roles/artifactregistry.writer"
  member  = each.value
}

resource "google_project_iam_member" "artifact_registry_reader" {
  for_each = toset(var.reader_members)

  project = data.google_project.project.project_id
  role    = "roles/artifactregistry.reader"
  member  = each.value
}
