
resource "google_certificate_manager_certificate_map" "horizon_sdv_map" {
  name        = "horizon-sdv-map"
  description = "Certificate Manager Map for Horizon SDV"
}

resource "google_certificate_manager_certificate_map_entry" "horizon_sdv_entry" {
  map         = google_certificate_manager_certificate_map.horizon_sdv_map.name
  name        = "horizon-sdv-entry"
  hostname    = "dev.horizon-sdv.scpmtk.com"
  certificates = ["horizon-sdv"]
}

