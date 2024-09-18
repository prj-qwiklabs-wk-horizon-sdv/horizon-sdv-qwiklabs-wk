terraform {
  backend "gcs" {
    bucket = "prj-s-agbg-gcp-sdv-sdb-tf"
    prefix = "prj-s-agbg-gcp-sdv-sdb-tf-state"
  }
}
