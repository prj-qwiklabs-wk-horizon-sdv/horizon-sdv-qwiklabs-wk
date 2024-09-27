
resource "google_integrations_auth_config" "horizon_sdv_oauth_2" {
  location     = var.auth_config_location
  display_name = var.auth_config_display_name
  description  = "OAuth 2 client id"
  decrypted_credential {
    credential_type = "oauth2_authorization_code"
    oauth2_authorization_code {
      auth_endpoint = var.auth_config_endpoint_uri
    }
  }
}

