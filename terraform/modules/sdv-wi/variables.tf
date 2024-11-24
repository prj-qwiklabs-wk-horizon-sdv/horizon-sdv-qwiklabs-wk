
variable "wi_service_accounts" {
  description = "A map of service accounts and their configurations"
  type = map(object({
    account_id   = string
    display_name = string
    description  = string
    gke_sas = list(object({
      gke_ns = string
      gke_sa = string
    }))
    roles = set(string)
  }))
}
