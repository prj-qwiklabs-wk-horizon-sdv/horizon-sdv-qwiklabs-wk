
variable "domain" {
  description = "Define the domain of the certificate"
  type        = string
}

variable "url_map_name" {
  description = "Define the name of the url map"
  type        = string
}

variable "target_https_proxy_name" {
  description = "Define the name of https proxy name"
  type        = string
}

variable "ssl_certificate_name" {
  description = "Define the SSL Certificate name"
  type        = string
}
