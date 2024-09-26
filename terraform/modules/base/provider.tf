provider "google" {
  project = var.sdv_project
  region  = var.sdv_region
}

provider "google-beta" {
  project = var.sdv_project
  region  = var.sdv_region
}
