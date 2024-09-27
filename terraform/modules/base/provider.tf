provider "google" {
  project = var.sdv_project
  region  = var.sdv_region
  zone    = var.sdv_zone
}

provider "google-beta" {
  project = var.sdv_project
  region  = var.sdv_region
  zone    = var.sdv_zone
}
