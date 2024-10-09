
data "google_project" "project" {}

resource "google_compute_managed_ssl_certificate" "custom_domain_certs" {
  name    = var.name
  project = data.google_project.project.project_id
  managed {
    domains = [var.domain]
  }
}

