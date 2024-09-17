resource "google_project_service" "project" {
  project = var.project_id
  service = "container.googleapis.com"
}

resource "google_project_service" "project_service" {
  project = var.project_id
  service = "iap.googleapis.com"
}


module "sdv-gke-cluster" {
  source          = "./modules/sdv-gke-cluster"
  cluster_name    = var.cluster_name
  node_pool_name  = var.cluster_node_pool_name
  location        = var.project_location
  network         = var.vpc_network_name
  subnetwork      = var.network_subnet_name
  service_account = var.computer_sa
}

module "sdv-bastion-host" {
  source          = "./modules/sdv-bastion-host"
  host_name       = var.bastion_host_name
  service_account = var.bastion_host_sa
  project         = var.project_id
  network         = var.vpc_network_name
  subnetwork      = var.network_subnet_name
  zone            = var.project_zone
  members         = var.bastion_host_members
}
