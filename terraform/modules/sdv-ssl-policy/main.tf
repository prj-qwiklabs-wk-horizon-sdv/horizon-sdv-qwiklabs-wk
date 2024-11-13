
data "google_project" "project" {}

resource "google_compute_ssl_policy" "gke_ssl_policy" {
  name            = var.name
  profile         = var.profile
  min_tls_version = var.min_tls_version
}
