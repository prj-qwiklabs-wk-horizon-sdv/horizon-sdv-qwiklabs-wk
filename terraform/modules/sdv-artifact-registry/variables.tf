
variable "repository_id" {
  description = "Define the name of the artifact repository"
  type        = string
}

variable "location" {
  description = "Define the location of the artifact registry"
  type        = string
}

variable "members" {
  description = "Define the users that have write access to the artifact registry"
  type         = list(string)
}
