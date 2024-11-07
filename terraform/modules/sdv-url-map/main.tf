
resource "google_compute_target_https_proxy" "default" {
  name    = var.target_https_proxy_name
  url_map = google_compute_url_map.default.id
  ssl_certificates = [
    var.ssl_certificate_name
  ]
}

resource "google_compute_url_map" "default" {
  name        = var.url_map_name
  description = "SSL certificate map description"

  default_service = google_compute_backend_service.default.id

  host_rule {
    hosts        = [var.domain]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.default.id

    path_rule {
      paths   = ["/*"]
      service = google_compute_backend_service.default.id
    }
  }
}

resource "google_compute_backend_service" "default" {
  name        = "backend-service"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10

  health_checks = [google_compute_http_health_check.default.id]
}

resource "google_compute_http_health_check" "default" {
  name               = "http-health-check"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}

resource "google_compute_global_forwarding_rule" "default" {
  name       = "forwarding-rule"
  target     = google_compute_target_https_proxy.default.id
  port_range = 443
}
