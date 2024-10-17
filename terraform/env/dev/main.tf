
# workflow build 064

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
  sdv_ssl_certificate_name   = "horizon-sdv-dev"

  # sdv-apis-services
  sdv_auth_config_display_name = "horizon-sdv-dev-oauth-2"
  sdv_auth_config_endpoint_uri = "https://horizon-sdv-dev.scpmtk.com/auth/realms/horizon/broker/google/endpoint"

  #
  # To create a new SA with access from GKE to GC, add a new saN block.
  #
  sdv_wi_service_accounts = {
    sa1 = {
      account_id   = "gke-jenkis-sa"
      display_name = "jenkis SA"
      description  = "the deployment of Jenkis in GKE cluster makes use of this account through WIF"

      gke_ns = "jenkis"
      gke_sa = "jenkis-sa"

      roles = toset([
        "roles/storage.objectUser",
        "roles/artifactregistry.writer",
      ])
    },
    sa2 = {
      account_id   = "gke-external-secrets-sa"
      display_name = "external-secrets SA"
      description  = "external-secrets/external-secrets-sa in GKE cluster makes use of this account through WI"

      gke_ns = "external-secrets"
      gke_sa = "external-secrets-sa"

      roles = toset([
        "roles/secretmanager.secretAccessor",
        "roles/iam.serviceAccountTokenCreator",
      ])
    },
    sa3 = {
      account_id   = "gke-keycloak-sa"
      display_name = "keycloak SA"
      description  = "keycloak/keycloak-sa in GKE cluster makes use of this account through WI"

      gke_ns = "keycloak"
      gke_sa = "keycloak-sa"

      roles = toset([
        "roles/secretmanager.secretAccessor",
        "roles/iam.serviceAccountTokenCreator",
      ])
    }
  }

  sdv_gh_app_id          = var.sdv_gh_app_id
  sdv_gh_installation_id = var.sdv_gh_installation_id

}
