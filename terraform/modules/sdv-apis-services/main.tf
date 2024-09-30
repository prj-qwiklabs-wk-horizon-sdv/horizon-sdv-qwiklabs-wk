
#
# https://cloud.google.com/application-integration/docs/configure-authentication-profiles#createAuthProfile
#

# resource "google_integrations_client" "client" {
#   project  = var.project
#   location = var.auth_config_location
# }

# resource "google_integrations_auth_config" "horizon_sdv_oauth_2" {

#   project      = var.project
#   location     = var.auth_config_location
#   display_name = var.auth_config_display_name
#   description  = "OAuth 2 client id"

#   decrypted_credential {
#     credential_type = "OAUTH2_CLIENT_CREDENTIALS"
#     oauth2_client_credentials {
#       client_id      = "horizon"
#       client_secret  = "fNqVUBkX7tDTFfxLiMPuWIICHf8vF0141Of"
#       scope          = "read"
#       token_endpoint = var.auth_config_endpoint_uri
#       request_type   = "ENCODED_HEADER"
#       token_params {
#         entries {
#           key {
#             literal_value {
#               string_value = "string-key"
#             }
#           }
#           value {
#             literal_value {
#               string_value = "string-value"
#             }
#           }
#         }
#       }
#     }
#   }
#   depends_on = [google_integrations_client.client]
# }

