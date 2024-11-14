resource "google_certificate_manager_certificate" "horizon_sdv_cert" {
  name        = "horizon-sdv"
  # description = "Certificate for Horizon SDV"
  scope       = "DEFAULT"
  managed {
    domains = ["dev.horizon-sdv.scpmtk.com"]
  }
}

resource "google_certificate_manager_certificate_map" "horizon_sdv_map" {
  name        = "horizon-sdv-map-dev"
  description = "Certificate Manager Map for Horizon SDV"
}

resource "google_certificate_manager_certificate_map_entry" "horizon_sdv_entry" {
  map         = google_certificate_manager_certificate_map.horizon_sdv_map.name
  name        = "horizon-sdv-dev-entry"
  hostname    = "dev.horizon-sdv.scpmtk.com"
  certificates = [google_certificate_manager_certificate.horizon_sdv_cert.name]
}
