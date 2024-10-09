resource "google_compute_router" "vpc_nat_router" {
  project = data.google_project.project.project_id
  name    = "${var.network}-${var.region}-nat-router"
  region  = var.region
  network = module.vpc.network_self_link
}

resource "google_compute_address" "vpc_nat_ip" {
  project = data.google_project.project.project_id
  name    = "${var.network}-${var.region}-egress-nat-ip"
  region  = var.region
}

resource "google_compute_router_nat" "vpc_nat" {
  project = data.google_project.project.project_id
  name    = "${var.network}-${var.region}-egress-nat"
  region  = var.region
  router  = google_compute_router.vpc_nat_router.name

  nat_ip_allocate_option = "AUTO_ONLY"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = module.vpc.subnets["${var.region}/${var.subnetwork}"].self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    filter = "TRANSLATIONS_ONLY"
    enable = true
  }
}
