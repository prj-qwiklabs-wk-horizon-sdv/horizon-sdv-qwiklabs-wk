

module "base" {
  source = "https://github.com/AGBG-ASG/acn-horizon-sdv/modules/base@1.0.0"

  sdv_gcs_name   = "prj-s-agbg-gcp-sdv-sdx-tf-state"
  sdv_gcs_prefix = "prj-s-agbg-gcp-sdv-sdx-tf-state"

  sdv_project  = "sdvb-2108202401"
  sdv_location = "europe-west1"
  sdv_region   = "europe-west1"
  sdv_zone     = "europe-west1-d"

  sdv_network    = "sdv-network"
  sdv_subnetwork = "sdv-subnet"

  sdv_default_computer_sa = "966518152012-compute@developer.gserviceaccount.com"

  sdv_cluster_name           = "sdv-cluster"
  sdv_cluster_node_pool_name = "sdv-node-pool"

  sdv_bastion_host_name = "sdv-bastion-host"
  sdv_bastion_host_sa   = "sdv-bastion-host-sa-iap"
  sdv_bastion_host_members = [
    "user:edson.schlei@accenture.com",
    "user:wojciech.kobryn@accenture.com",
    "user:marta.kania@accenture.com"
  ]

  sdv_network_egress_router_name = "sdv-egress-internet"

}
