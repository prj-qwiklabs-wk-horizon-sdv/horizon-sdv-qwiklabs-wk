
data "google_project" "project" {}

# Read the content of the local text file into a local variable
locals {
  file_content = file("${var.file}")
}

resource "terraform_data" "debug_file_content" {
  input = local.file_content
}

resource "null_resource" "copy_to_bastion" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
      gcloud beta compute ssh ${var.bastion_host} --zone=${var.zone} --project=${data.google_project.project.project_id} --command="
      echo ${local.file_content} > ${var.destination_path}
    "
    EOT
  }
}

resource "google_storage_bucket" "bucket" {
  name                        = "${data.google_project.project.project_id}-scripts"
  location                    = var.location
  uniform_bucket_level_access = true
}


# Example usage in a Google Cloud resource (e.g., a Storage Bucket object)
resource "google_storage_bucket_object" "horizon_stage_01_sh" {
  name   = "bash-scripts/horizon-stage-01.sh"
  bucket = google_storage_bucket.bucket.name
  content = local.file_content
}