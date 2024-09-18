
project_id       = "sdvc-2108202401"
project_location = "europe-west1"
project_region   = "europe-west1"
project_zone     = "europe-west1-d"

vpc_network_name    = "sdv-network"
network_subnet_name = "sdv-subnet"

computer_sa = "966518152012-compute@developer.gserviceaccount.com"


cluster_name           = "sdv-cluster"
cluster_node_pool_name = "sdv-node-pool"

bastion_host_name    = "sdv-bastion-host"
bastion_host_sa      = "sdv-bastion-host-sa-iap"
bastion_host_members = ["user:edson.schlei@accenture.com", "user:wojciech.kobryn@accenture.com", "user:marta.kania@accenture.com"]

sdv_network_egress_router_name = "sdv-egress-internet"
