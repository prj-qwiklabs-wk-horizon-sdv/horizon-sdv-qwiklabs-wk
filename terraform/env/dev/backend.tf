terraform {
  required_version = "= 1.9.6"
  backend "gcs" {
    bucket = "prj-s-agbg-gcp-sdv-dev-tf"
    prefix = "prj-s-agbg-gcp-sdv-dev-tf-state"
  }
}
