
variable "bastion_host" {
  description = "Define of the bastion host"
  type        = string
}

variable "zone" {
  description = "Define the region zone"
  type        = string
}

variable "command" {
  description = "Define the commands to run"
  type        = string
}
