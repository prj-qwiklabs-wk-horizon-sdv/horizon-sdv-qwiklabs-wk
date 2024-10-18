data "google_project" "project" {}

resource "google_service_account" "sdv_wi_sa" {
  for_each = var.wi_service_accounts

  project      = data.google_project.project.project_id
  account_id   = each.value.account_id
  display_name = each.value.display_name
  description  = each.value.description
}

locals {
  # role with the list of SAs merged into one list of SAs
  merged_roles_with_sa = {
    for role in toset(flatten([for sa in values(var.wi_service_accounts) : sa.roles])) :
    role => toset([for sa_key, sa in var.wi_service_accounts : sa_key if contains(sa.roles, role)])
  }
}

# resource "terraform_data" "debug_merged_roles_with_sa" {
#   input = local.merged_roles_with_sa
# }

resource "google_service_account_iam_binding" "sdv_wi_sa_wi_users" {
  for_each = { for idx, sdv_sa in google_service_account.sdv_wi_sa : idx => sdv_sa }

  service_account_id = each.value.id

  role = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${data.google_project.project.project_id}.svc.id.goog[${var.wi_service_accounts[each.key].gke_ns}/${var.wi_service_accounts[each.key].gke_sa}]",
  ]

  depends_on = [
    google_service_account.sdv_wi_sa
  ]
}

#
# Add SAs to the Roles
resource "google_project_iam_binding" "sdv_wi_sa_iam" {
  for_each = local.merged_roles_with_sa

  project = data.google_project.project.project_id
  role    = each.key

  members = [
    for sa in each.value : "serviceAccount:${google_service_account.sdv_wi_sa[sa].email}"
  ]

  depends_on = [
    google_service_account.sdv_wi_sa
  ]
}
