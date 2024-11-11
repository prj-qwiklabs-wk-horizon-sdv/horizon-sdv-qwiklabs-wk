
data "google_project" "project" {}

# resource "terraform_data" "debug_google_project" {
#   input = data.google_project.project
# }

resource "google_compute_instance" "sdv_custom_image" {
  name         = var.compute_instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.base_image
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
  }

  metadata_startup_script = var.metadata_startup_script
}

resource "google_compute_snapshot" "custom_snapshot" {
  name              = var.snapshot_name
  source_disk       = google_compute_instance.sdv_custom_image.boot_disk[0].source
  zone              = google_compute_instance.sdv_custom_image.zone
  storage_locations = var.storage_locations

  depends_on = [
    google_compute_instance.sdv_custom_image
  ]
}

resource "google_compute_image" "custom_image" {
  name              = var.image_name
  source_snapshot   = google_compute_snapshot.custom_snapshot.self_link
  family            = var.custom_image_family
  storage_locations = var.storage_locations

  depends_on = [
    google_compute_snapshot.custom_snapshot
  ]
}


resource "null_resource" "delete_instance" {
  provisioner "local-exec" {
    command = "gcloud compute instances delete ${google_compute_instance.sdv_custom_image.name} --project=${google_compute_instance.sdv_custom_image.project} --zone=${google_compute_instance.sdv_custom_image.zone} --quiet"
  }

  depends_on = [
    google_compute_image.custom_image
  ]
}
