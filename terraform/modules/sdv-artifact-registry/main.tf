
resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.location
  repository_id = var.repository_id
  format        = "DOCKER"
  description   = "Docker repository for Horizon SDV Dev"
}
