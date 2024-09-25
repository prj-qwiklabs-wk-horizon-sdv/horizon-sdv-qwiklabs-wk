
resource "google_compute_managed_ssl_certificate" "custom_domain_certs" {
  name    = var.name
  project = var.project
  managed {
    domains = [var.domain]
  }
}

