data "google_project" "project" {}

resource "google_certificate_manager_certificate" "horizon_sdv_cert" {
  project = data.google_project.project.project_id
  name    = var.name
  scope   = "DEFAULT"
  managed {
    domains = [
      var.domain
    ]
  }
}

resource "google_certificate_manager_certificate_map" "horizon_sdv_map" {
  project     = data.google_project.project.project_id
  name        = "horizon-sdv-map-dev"
  description = "Certificate Manager Map for Horizon SDV"
}

# resource "google_certificate_manager_certificate_map_entry" "horizon_sdv_entry" {
#   map         = google_certificate_manager_certificate_map.horizon_sdv_map.name
#   name        = "horizon-sdv-dev-entry"
#   hostname    = "dev.horizon-sdv.scpmtk.com"
#   certificates = [google_certificate_manager_certificate.horizon_sdv_cert.name]
# }
