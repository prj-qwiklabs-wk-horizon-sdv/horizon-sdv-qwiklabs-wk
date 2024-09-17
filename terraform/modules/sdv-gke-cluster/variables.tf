
variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "node_pool_name" {
  description = "Name of the cluster node pool"
  type        = string
}

variable "network" {
  description = "Name of the network"
  type        = string
}

variable "subnetwork" {
  description = "Name of the subnetwork"
  type        = string
}


variable "location" {
  description = "Define the default location for the project"
  type        = string
}

variable "machine_type" {
  description = "Define the machine type of the node poll"
  type        = string
  default     = "e2-medium"
}

variable "service_account" {
  description = "Define the service account of the node poll"
  type        = string
}

variable "node_locations" {
  description = "Define the location of the nodes"
  type        = list(string)
  default = [
    "europe-west1-d",
  ]
}




