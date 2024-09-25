variable "name" {
  default = "Define the name of the certificate"
  type    = string
}

variable "project" {
  description = "Define the project id"
  type        = string
}

variable "domain" {
  description = "Define the domain of the certificate"
  type        = string
}
