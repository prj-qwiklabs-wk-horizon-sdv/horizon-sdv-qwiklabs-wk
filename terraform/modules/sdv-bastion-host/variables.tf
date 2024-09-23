
variable "project" {
  description = "Define the GCP project id"
  type        = string
}

variable "service_account" {
  description = "Define the Service account"
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

variable "source_image" {
  description = "Define the Source image"
  type        = string
  default     = "projects/debian-cloud/global/images/debian-12-bookworm-v20240815"
}

variable "host_name" {
  description = "Define the host name"
  type        = string
}

variable "zone" {
  description = "Define the zone"
  type        = string
}

variable "members" {
  description = "List of members allowed to access the bastion server"
  type        = list(string)
}

variable "machine_type" {
  description = "Machine type for the bastion host"
  type        = string
  default     = "n1-standard-1"
}
