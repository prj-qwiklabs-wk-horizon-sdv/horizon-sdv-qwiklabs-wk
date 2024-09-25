
# workflow build 012

module "base" {
  source = "../../modules/base"

  sdv_project  = "sdva-2108202401"
  sdv_location = "europe-west1"
  sdv_region   = "europe-west1"
  sdv_zone     = "europe-west1-d"

  sdv_network    = "sdv-network"
  sdv_subnetwork = "sdv-subnet"

  sdv_default_computer_sa = "268541173342-compute@developer.gserviceaccount.com"

  sdv_cluster_name                   = "sdv-cluster"
  sdv_cluster_node_pool_name         = "sdv-node-pool"
  sdv_cluster_node_pool_machine_type = "n1-standard-4"
  sdv_cluster_node_pool_count        = 3

  sdv_bastion_host_name = "sdv-bastion-host"
  sdv_bastion_host_sa   = "sdv-bastion-host-sa-iap"
  sdv_bastion_host_members = [
    "user:edson.schlei@accenture.com",
    "user:wojciech.kobryn@accenture.com",
    "user:marta.kania@accenture.com"
  ]

  sdv_network_egress_router_name = "sdv-egress-internet"

  sdv_artifact_registry_repository_id = "horizon-sdv-dev"

  sdv_ssl_certificate_domain = "horizon-sdv-dev.scpmtk.com"
}
