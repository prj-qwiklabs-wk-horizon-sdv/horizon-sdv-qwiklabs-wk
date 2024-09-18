resource "google_project_service" "project" {
  project = var.sdv_project
  service = "container.googleapis.com"
}

resource "google_project_service" "project_service" {
  project = var.sdv_project
  service = "iap.googleapis.com"
}


module "sdv-gke-cluster" {
  source          = "./modules/sdv-gke-cluster"
  cluster_name    = var.sdv_cluster_name
  node_pool_name  = var.sdv_cluster_node_pool_name
  location        = var.sdv_location
  network         = var.sdv_network
  subnetwork      = var.sdv_subnetwork
  service_account = var.sdv_default_computer_sa
}

module "sdv-bastion-host" {
  source          = "./modules/sdv-bastion-host"
  host_name       = var.sdv_bastion_host_name
  service_account = var.sdv_bastion_host_sa
  project         = var.sdv_project
  network         = var.sdv_network
  subnetwork      = var.sdv_subnetwork
  zone            = var.sdv_zone
  members         = var.sdv_bastion_host_members
}

module "sdv-network" {
  source      = "./modules/sdv-network"
  project     = var.sdv_project
  network     = var.sdv_network
  subnetwork  = var.sdv_subnetwork
  region      = var.sdv_region
  router_name = var.sdv_network_egress_router_name
}

