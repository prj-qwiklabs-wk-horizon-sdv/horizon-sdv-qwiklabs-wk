
variable "image_name" {
  description = "Define the name of the custom generated image"
  type        = string
}

variable "compute_instance_name" {
  description = "Define the Computer instance custom image name"
  type        = string
}

variable "machine_type" {
  description = "Define the machine type of the computer instance used to create the custom image"
  type        = string
}

variable "zone" {
  description = "Define the zone where the computer instance is created"
  type        = string
}

variable "base_image" {
  description = "The base image used to create the custom image"
  type        = string
}

variable "network" {
  description = "Define the name of the VPC network"
  type        = string
}

variable "subnetwork" {
  description = "Define the subnet name"
  type        = string
}

variable "metadata_startup_script" {
  description = "Script to be executed during the computer instance start up"
  type        = string
}

variable "snapshot_name" {
  description = "Define the name of the snapshot of the computer instance"
  type        = string
}

variable "storage_locations" {
  description = "Define the locations where the image and snapshoot are generated"
  type        = list(string)
}

variable "custom_image_family" {
  description = "Define the custom image familyname"
  type        = string
}
