
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.1"

  project_id   = var.project
  network_name = var.network
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name              = var.subnetwork
      subnet_region            = var.region
      subnet_ip                = "10.1.0.0/24"
      enable_ula_internal_ipv6 = true
    }
  ]

  secondary_ranges = {
    "${var.subnetwork}" = [
      {
        range_name    = "pod-ranges"
        ip_cidr_range = "10.10.0.0/20"
      },
      {
        range_name    = "services-range"
        ip_cidr_range = "10.10.16.0/20"
      },
    ]
  }

  routes = [
    {
      name                     = var.router_name
      description              = "route through IGW to access internet"
      destination_range        = "0.0.0.0/0"
      tags                     = "egress-inet"
      next_hop_internet        = "true"
      private_ip_google_access = true
    }
  ]
}
