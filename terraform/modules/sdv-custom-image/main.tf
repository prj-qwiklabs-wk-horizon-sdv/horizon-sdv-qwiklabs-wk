
data "google_project" "project" {}

# resource "terraform_data" "debug_google_project" {
#   input = data.google_project.project
# }

resource "google_compute_instance" "sdv_custom_image" {
  name         = "ubuntu-with-gcloud"
  machine_type = "n1-standard-1"
  zone         = "europe-west1-d"

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts"
    }
  }

  network_interface {
    network    = "sdv-network"
    subnetwork = "sdv-subnet"
    # access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    sudo apt-get update && sudo apt-get install google-cloud-sdk -y
  EOT
}

resource "google_compute_image" "custom_image" {
  name        = "ubuntu-with-gcloud-image"
  source_disk = google_compute_instance.sdv_custom_image.self_link
  family      = "ubuntu-with-gcloud"

  depends_on = [
    google_compute_instance.sdv_custom_image
  ]

  provisioner "local-exec" {
    command = "gcloud compute instances stop ${google_compute_instance.sdv_custom_image.name} --zone=${google_compute_instance.sdv_custom_image.zone}"
  }
}

resource "google_compute_snapshot" "custom_snapshot" {
  name        = "ubuntu-with-gcloud-snapshot"
  source_disk = google_compute_instance.sdv_custom_image.boot_disk[0].source
  zone        = google_compute_instance.sdv_custom_image.zone

  depends_on = [
    google_compute_instance.sdv_custom_image
  ]
}

resource "google_compute_image" "custom_image" {
  name        = "ubuntu-with-gcloud-image"
  source_snapshot = google_compute_snapshot.custom_snapshot.self_link
  family      = "ubuntu-with-gcloud"

  depends_on = [
    google_compute_snapshot.custom_snapshot
  ]
}