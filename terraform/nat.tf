resource "google_compute_router" "vpc_router" {
  project = var.project_id

  name    = "${var.vpc_network_name}-${var.project_region}-nat-router"
  region  = var.project_region
  network = module.vpc.network_self_link
}

resource "google_compute_address" "vpc_nat_ip" {
  project = var.project_id

  name   = "${var.vpc_network_name}-${var.project_region}-egress-nat-ip"
  region = var.project_region
}

resource "google_compute_router_nat" "vpc_nat" {
  project = var.project_id

  name   = "${var.vpc_network_name}-${var.project_region}-egress-nat"
  region = var.project_region
  router = google_compute_router.vpc_router.name

  nat_ip_allocate_option = "AUTO_ONLY"
  # nat_ips                = google_compute_address.vpc_nat_ip
  # nat_ips                = google_compute_address.vpc_nat_ip.self_link

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    # name                    = module.vpc.subnets["${var.project_region}/${var.vpc_network_name}-${var.project_region}-private"].self_link
    name                    = module.vpc.subnets["${var.project_region}/${var.network_subnet_name}"].self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  log_config {
    filter = "TRANSLATIONS_ONLY"
    enable = true
  }
}
