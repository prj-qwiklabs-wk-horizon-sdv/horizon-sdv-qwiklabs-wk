

# resource "google_iam_policy" "artifact_registry_policy" {
#   project = google_container_cluster.cluster.project_id
#   resource = google_artifact_registry_repository.repository.name

#   bindings = {
#     "role": "roles/artifactregistry.reader",
#     "members": [
#       "serviceAccount:${google_container_cluster.cluster.location}/${google_container_cluster.cluster.project_id}.svc.id.goog/${google_container_cluster.cluster.name}-sa"
#     ]
#   }
# }

# resource "google_iam_policy" "storage_policy" {
#   project = google_container_cluster.cluster.project_id
#   resource = google_storage_bucket.bucket.name

#   bindings = {
#     "role": "roles/storage.objectViewer",
#     "members": [
#       "serviceAccount:${google_container_cluster.cluster.location}/${google_container_cluster.cluster.project_id}.svc.id.goog/${google_container_cluster.cluster.name}-sa"
#     ]
#   }
# }