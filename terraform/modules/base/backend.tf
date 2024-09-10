terraform {
  backend "gcs" {
    bucket = "prj-s-agbg-gcp-sdv-dev-tf-state"
    prefix = "prj-s-agbg-gcp-sdv-dev-tf-state"
  }
}
