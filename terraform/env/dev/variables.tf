variable "sdv_secret" {
  description = "The value of the sdv-secret, the value is defined by the environment variable: TF_VAR_sdv_secret"
  type        = string
}

variable "sdv_gh_app_id" {
  description = "The gh_app_id secret"
  type        = string
}

variable "sdv_gh_installation_id" {
  description = "The gh_installation_id secret"
  type        = string
}
