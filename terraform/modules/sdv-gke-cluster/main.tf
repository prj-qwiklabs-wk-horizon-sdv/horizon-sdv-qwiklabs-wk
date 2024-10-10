
data "google_project" "project" {}

resource "google_container_cluster" "sdv_cluster" {
  project                  = data.google_project.project.project_id
  name                     = var.cluster_name
  location                 = var.location
  network                  = var.network
  subnetwork               = var.subnetwork
  remove_default_node_pool = true
  initial_node_count       = 1

  # Set `deletion_protection` to `true` will ensure that one cannot
  # accidentally delete this instance by use of Terraform.
  deletion_protection = false

  master_authorized_networks_config {
    gcp_public_cidrs_access_enabled = false
  }

  ip_allocation_policy {
    stack_type                    = "IPV4"
    cluster_secondary_range_name  = "pod-ranges"
    services_secondary_range_name = "services-range"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "10.0.0.0/28"
  }

  secret_manager_config {
    enabled = true
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }
    gcp_filestore_csi_driver_config {
      enabled = true
    }
  }

  # Enable autoscaling
  cluster_autoscaling {
    enabled = true

    resource_limits {
      resource_type = "cpu"
      minimum       = 1
      maximum       = 8
    }

    resource_limits {
      resource_type = "memory"
      minimum       = 1
      maximum       = 32
    }
  }

}


resource "google_container_node_pool" "sdv_main_node_pool" {
  name           = var.node_pool_name
  location       = var.location
  cluster        = google_container_cluster.sdv_cluster.name
  node_count     = var.node_count
  node_locations = var.node_locations
  node_config {
    preemptible  = true
    machine_type = var.machine_type

    # Google recommends custom service accounts that have cloud-platform
    # scope and permissions granted via IAM Roles.
    service_account = var.service_account
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

}

resource "google_container_node_pool" "sdv_build_node_pool" {
  name           = var.build_node_pool_name
  location       = var.location
  cluster        = google_container_cluster.sdv_cluster.name
  node_count     = var.build_node_pool_node_count
  node_locations = var.node_locations
  node_config {
    preemptible  = true
    machine_type = var.build_node_pool_machine_type

    # Google recommends custom service accounts that have cloud-platform
    # scope and permissions granted via IAM Roles.
    service_account = var.service_account
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      workloadLabel = "android"
    }

    taint {
      key    = "workloadType"
      value  = "android"
      effect = "NO_SCHEDULE"
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

  autoscaling {
    min_node_count = var.build_node_pool_min_node_count
    max_node_count = var.build_node_pool_max_node_count
  }

}






# resource "google_iam_policy" "artifact_registry_policy" {
#   project = google_container_cluster.sdv_cluster.project_id
#   resource = module.sdv_artifact_registry.docker_repo.repository.name

#   bindings = {
#     "role": "roles/artifactregistry.reader",
#     "members": [
#       "serviceAccount:${google_container_cluster.sdv_cluster.location}/${google_container_cluster.sdv_cluster.project_id}.svc.id.goog/${google_container_cluster.sdv_cluster.name}-sa"
#     ]
#   }
# }

# resource "google_iam_policy" "storage_policy" {
#   project = google_container_cluster.sdv_cluster.project_id
#   resource = "${google_project.project.project_id}-aaos"

#   bindings = {
#     "role": "roles/storage.objectUser",
#     "members": [
#       "serviceAccount:${google_container_cluster.sdv_cluster.location}/${google_container_cluster.sdv_cluster.project_id}.svc.id.goog/${google_container_cluster.sdv_cluster.name}-sa"
#     ]
#   }
# }

