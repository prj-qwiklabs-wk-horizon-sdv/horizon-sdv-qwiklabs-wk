provider "google" {
  project = var.sdv_project
  region  = "europe-west1"
}
provider "google-beta" {
  project = var.sdv_project
  region  = "europe-west1"
}
