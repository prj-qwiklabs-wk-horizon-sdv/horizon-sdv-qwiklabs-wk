
variable "project" {
  description = "Define the GCP project id"
  type        = string
}

variable "region" {
  description = "Define the Region"
  type        = string
}

variable "network" {
  description = "Define the Network"
  type        = string
}

variable "subnetwork" {
  description = "Define the Sub Network"
  type        = string
}

variable "router_name" {
  description = "Define the router name"
  type        = string
}
