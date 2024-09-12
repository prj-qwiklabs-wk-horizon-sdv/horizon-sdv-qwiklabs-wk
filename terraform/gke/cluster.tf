resource "google_container_cluster" "default" {
  name                     = var.cluster_name
  location                 = var.project_location
  network                  = var.vpc_network_name
  subnetwork               = var.network_subnet_name
  remove_default_node_pool = true
  initial_node_count       = 1

  # Set `deletion_protection` to `true` will ensure that one cannot
  # accidentally delete this instance by use of Terraform.
  deletion_protection = false

  private_cluster_config {
    enable_private_nodes   = true
    master_ipv4_cidr_block = "10.0.0.0/28"
  }
}


resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = var.cluster_node_pool_name
  location   = var.project_location
  cluster    = google_container_cluster.default.name
  node_count = 1
  node_locations = [
    "europe-west1-d",
  ]
  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    # Google recommends custom service accounts that have cloud-platform
    # scope and permissions granted via IAM Roles.
    service_account = var.computer_sa
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

}
