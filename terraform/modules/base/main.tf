
resource "google_project_service" "project" {
  project = var.sdv_project
  service = "container.googleapis.com"
}

resource "google_project_service" "project_service" {
  project = var.sdv_project
  service = "iap.googleapis.com"
}

resource "google_project_service" "certificate_manager_api" {
  project = var.sdv_project
  service = "certificatemanager.googleapis.com"
}

module "sdv_network" {
  source = "../sdv-network"

  project     = var.sdv_project
  network     = var.sdv_network
  subnetwork  = var.sdv_subnetwork
  region      = var.sdv_region
  router_name = var.sdv_network_egress_router_name
}

module "sdv_bastion_host" {
  source = "../sdv-bastion-host"

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
  source = "../sdv-gke-cluster"

  cluster_name    = var.sdv_cluster_name
  node_pool_name  = var.sdv_cluster_node_pool_name
  location        = var.sdv_location
  network         = var.sdv_network
  subnetwork      = var.sdv_subnetwork
  service_account = var.sdv_default_computer_sa
  machine_type    = var.sdv_cluster_node_pool_machine_type
  node_count      = var.sdv_cluster_node_pool_count
  depends_on      = [module.sdv_bastion_host]
}

module "sdv_artifact_registry" {
  source = "../sdv-artifact-registry"

  repository_id = var.sdv_artifact_registry_repository_id
  location      = var.sdv_location
}

module "sdv_ssl_certificate" {
  source = "../sdv-ssl-certificate"

  project = var.sdv_project
  name    = var.sdv_ssl_certificate_name
  domain  = var.sdv_ssl_certificate_domain
}

module "sdv_url_map" {
  source = "../sdv-url-map"

  target_https_proxy_name = var.sdv_target_https_proxy_name
  url_map_name            = var.sdv_url_map_name
  ssl_certificate_name    = var.sdv_ssl_certificate_name
  domain                  = var.sdv_ssl_certificate_domain
  depends_on              = [module.sdv_ssl_certificate]
}
