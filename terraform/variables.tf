
variable "vpc_network_name" {
  description = "Define the name of the VPC network"
  type        = string
}

variable "project_id" {
  description = "Define the GCP project id"
  type        = string
}

variable "project_location" {
  description = "Define the default location for the project"
  type        = string
}

variable "project_region" {
  description = "Define the default region for the project"
  type        = string
}

variable "project_zone" {
  description = "Define the default region zone for the project"
  type        = string
}

variable "network_subnet_name" {
  description = "Define the subnet name"
  type        = string
}

variable "computer_sa" {
  description = "Computer SA"
  type        = string
}

variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "cluster_node_pool_name" {
  description = "Name of the cluster node pool"
  type        = string
}

variable "bastion_host_name" {
  description = "Name of the bastion host server"
  type        = string
}

variable "bastion_host_members" {
  description = "List of members allowed to access the bastion server"
  type        = list(string)
}

variable "bastion_host_sa" {
  description = "SA used by the bastion host and allow IAP to the host"
  type        = string
}
