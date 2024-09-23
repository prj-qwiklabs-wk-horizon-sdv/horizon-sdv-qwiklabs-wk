resource "google_project_service" "project" {
  project = var.sdv_project
  service = "container.googleapis.com"
}

resource "google_project_service" "project_service" {
  project = var.sdv_project
  service = "iap.googleapis.com"
}

module "sdv_network" {
  source      = "../sdv-network"
  project     = var.sdv_project
  network     = var.sdv_network
  subnetwork  = var.sdv_subnetwork
  region      = var.sdv_region
  router_name = var.sdv_network_egress_router_name
}

module "sdv_bastion_host" {
  source          = "../sdv-bastion-host"
  host_name       = var.sdv_bastion_host_name
  service_account = var.sdv_bastion_host_sa
  project         = var.sdv_project
  network         = var.sdv_network
  subnetwork      = var.sdv_subnetwork
  zone            = var.sdv_zone
  members         = var.sdv_bastion_host_members
  depends_on      = [module.sdv_network]
}

module "sdv_gke_cluster" {
  source          = "../sdv-gke-cluster"
  cluster_name    = var.sdv_cluster_name
  node_pool_name  = var.sdv_cluster_node_pool_name
  location        = var.sdv_location
  network         = var.sdv_network
  subnetwork      = var.sdv_subnetwork
  service_account = var.sdv_default_computer_sa
  machine_type    = "n1-standard-4"
  node_count      = 3
  depends_on      = [module.sdv_bastion_host]
}

