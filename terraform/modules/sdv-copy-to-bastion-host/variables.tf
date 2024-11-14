
variable "files" {
  description = "The path of the files that needs to be copied."
  type        = list(string)
}

variable "bastion_host_name" {
  description = "The name of the bastion host."
  type        = string
}

variable "destination_path" {
  description = "The destination path for the file"
  type        = string
}

variable "zone" {
  description = "Define the region zone"
  type        = string
}
