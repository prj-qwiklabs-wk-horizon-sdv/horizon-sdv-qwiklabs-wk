terraform {
  backend "gcs" {
    bucket = "prj-s-agbg-gcp-sdv-sdx-tf-state"
    prefix = "prj-s-agbg-gcp-sdv-sdx-tf-state"
  }
}
