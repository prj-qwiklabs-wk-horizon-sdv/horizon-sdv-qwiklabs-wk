terraform {
  backend "gcs" {
    bucket = "prj-s-agbg-gcp-sdv-dev-tf"
    prefix = "prj-s-agbg-gcp-sdv-dev-tf-state"
  }
}
