
output "vpc_nat_router_name" {
  description = "The name of the created router for NAT."
  value       = google_compute_router.vpc_nat_router.name
}

output "vpc_nat_name" {
  description = "The name of the created NAT."
  value       = google_compute_router_nat.vpc_nat.name
}

output "vpc_nat_ip_name" {
  description = "The name of the created NAT ip address"
  value       = google_compute_address.vpc_nat_ip.name
}
