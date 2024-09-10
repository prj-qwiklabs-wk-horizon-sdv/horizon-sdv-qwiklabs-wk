
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.1"

  project_id   = var.project_id
  network_name = var.vpc_network_name
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name              = var.network_subnet_name
      subnet_region            = var.project_region
      subnet_ip                = "10.1.0.0/24"
      enable_ula_internal_ipv6 = true
      # stack_type               = "IPV4_IPV6"
      # ipv6_access_type         = "INTERNAL"
    }
  ]

  routes = [
    {
      name                     = "sdv-egress-internet"
      description              = "route through IGW to access internet"
      destination_range        = "0.0.0.0/0"
      tags                     = "egress-inet"
      next_hop_internet        = "true"
      private_ip_google_access = true
    }
  ]

  # secondary_ranges = {
  #   subnet-01 = [
  #     {
  #       range_name    = "services-range"
  #       ip_cidr_range = "192.168.0.0/24"
  #     },
  #     {
  #       range_name    = "pod-ranges"
  #       ip_cidr_range = "192.168.1.0/24"
  #     }
  #   ]
  # }

}
