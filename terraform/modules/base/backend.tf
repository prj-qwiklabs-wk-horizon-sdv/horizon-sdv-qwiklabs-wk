terraform {
  backend "gcs" {
    bucket = var.sdv_gcs_bucket_name
    prefix = var.sdv_gcs_prefix
  }
}
