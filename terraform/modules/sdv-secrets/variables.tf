variable "sdv_secret" {
  description = "The value of the sdv-secret, the value is defined by the environment variable: TF_VAR_sdv_secret"
  type        = string
}

variable "location" {
  description = "Define the secret replication location"
  type        = string
}
