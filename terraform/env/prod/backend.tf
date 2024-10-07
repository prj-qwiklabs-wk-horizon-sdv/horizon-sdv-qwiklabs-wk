terraform {
  required_version = ">= 1.9.6"
  backend "gcs" {
    bucket = "prj-s-agbg-gcp-sdv-sdb-tf"
    prefix = "prj-s-agbg-gcp-sdv-sdb-tf-state"
  }
}
