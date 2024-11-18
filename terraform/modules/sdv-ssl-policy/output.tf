
output "ssl_policy_id" {
  description = "The ID of the created SSL policy."
  value       = google_compute_ssl_policy.gke_ssl_policy.id
}

output "ssl_policy_self_link" {
  description = "The self link of the created SSL policy."
  value       = google_compute_ssl_policy.gke_ssl_policy.self_link
}
