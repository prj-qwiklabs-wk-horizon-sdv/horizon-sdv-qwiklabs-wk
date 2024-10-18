
data "google_project" "project" {}

module "sdv_apis" {
  source = "../sdv-apis"
}

module "sdv_secrets" {
  source = "../sdv-secrets"

  location    = var.sdv_location
  gcp_secrets_map = var.sdv_gcp_secrets_map
}

module "sdv_wi" {
  source = "../sdv-wi"

  wi_service_accounts = var.sdv_wi_service_accounts
}

module "sdv_gcs" {
  source = "../sdv-gcs"

  location = var.sdv_location
}

module "sdv_network" {
  source = "../sdv-network"

  network     = var.sdv_network
  subnetwork  = var.sdv_subnetwork
  region      = var.sdv_region
  router_name = var.sdv_network_egress_router_name
}

module "sdv_bastion_host" {
  source = "../sdv-bastion-host"
  depends_on = [
    module.sdv_apis,
    module.sdv_network
  ]

  host_name       = var.sdv_bastion_host_name
  service_account = var.sdv_bastion_host_sa
  network         = var.sdv_network
  subnetwork      = var.sdv_subnetwork
  zone            = var.sdv_zone
  members         = var.sdv_bastion_host_members
}

module "sdv_gke_cluster" {
  source = "../sdv-gke-cluster"
  depends_on = [
    module.sdv_apis,
    module.sdv_bastion_host,
    module.sdv_gcs,
    module.sdv_wi,
  ]

  project_id      = data.google_project.project.project_id
  cluster_name    = var.sdv_cluster_name
  location        = var.sdv_location
  network         = var.sdv_network
  subnetwork      = var.sdv_subnetwork
  service_account = var.sdv_default_computer_sa

  # Default node pool configuration
  node_pool_name = var.sdv_cluster_node_pool_name
  machine_type   = var.sdv_cluster_node_pool_machine_type
  node_count     = var.sdv_cluster_node_pool_count

  # build node pool configuration
  build_node_pool_name           = var.sdv_build_node_pool_name
  build_node_pool_node_count     = var.sdv_build_node_pool_node_count
  build_node_pool_machine_type   = var.sdv_build_node_pool_machine_type
  build_node_pool_min_node_count = var.sdv_build_node_pool_min_node_count
  build_node_pool_max_node_count = var.sdv_build_node_pool_max_node_count
}

module "sdv_artifact_registry" {
  source = "../sdv-artifact-registry"

  repository_id = var.sdv_artifact_registry_repository_id
  location      = var.sdv_location
}

module "sdv_ssl_certificate" {
  source     = "../sdv-ssl-certificate"
  depends_on = [module.sdv_apis]

  project = var.sdv_project
  name    = var.sdv_ssl_certificate_name
  domain  = var.sdv_ssl_certificate_domain

}

module "sdv_url_map" {
  source     = "../sdv-url-map"
  depends_on = [module.sdv_ssl_certificate]

  target_https_proxy_name = var.sdv_target_https_proxy_name
  url_map_name            = var.sdv_url_map_name
  ssl_certificate_name    = var.sdv_ssl_certificate_name
  domain                  = var.sdv_ssl_certificate_domain
}

#
# Can create it only after deploy keycloack
#
# module "sdv_apis_services" {
#   source     = "../sdv-apis-services"
#   depends_on = [module.sdv_apis]

#   project                  = var.sdv_project
#   auth_config_location     = var.sdv_location
#   auth_config_display_name = var.sdv_auth_config_display_name
#   auth_config_endpoint_uri = var.sdv_auth_config_endpoint_uri
# }
