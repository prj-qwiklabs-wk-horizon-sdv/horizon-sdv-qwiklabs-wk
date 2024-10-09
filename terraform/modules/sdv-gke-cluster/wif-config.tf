

# resource "google_iam_workload_identity_pool" "pool" {
#   workload_identity_pool_id = "my-pool"
#   display_name              = "My Workload Identity Pool"
#   description               = "A pool for my GKE cluster"
# }

# resource "google_iam_workload_identity_pool_provider" "provider" {
#   workload_identity_pool_id = google_iam_workload_identity_pool.pool.workload_identity_pool_id
#   workload_identity_pool_provider_id = "my-provider"
#   display_name               = "My OIDC Provider"
#   description                = "A provider for my GKE cluster"

#   oidc {
#     issuer_uri = "https://container.googleapis.com/v1/projects/${var.project_id}/locations/${var.region}/clusters/${var.cluster_name}"
#   }

#   attribute_mapping = {
#     "google.subject" = "assertion.sub"
#     "attribute.aud"  = "assertion.aud"
#   }
# }
