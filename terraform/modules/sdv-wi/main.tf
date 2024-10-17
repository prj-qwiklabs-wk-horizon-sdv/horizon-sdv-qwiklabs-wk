data "google_project" "project" {}

locals {
  sdv_sas                 = var.wi_service_accounts
  sdv_wi_service_accounts = var.wi_service_accounts
}

resource "google_service_account" "sdv_wi_sa" {
  for_each = local.sdv_wi_service_accounts

  project      = data.google_project.project.project_id
  account_id   = each.value.account_id
  display_name = each.value.display_name
  description  = each.value.description
}


locals {

  new_roles = {
    for role in flatten([for sa in values(local.sdv_wi_service_accounts) : sa.roles]) :
    role => role...
  }

  roles_with_sa = {
    for role in flatten([for sa in values(local.sdv_wi_service_accounts) : sa.roles]) :
    role => [for indx, sa in local.sdv_wi_service_accounts : indx if contains(sa.roles, role)]...
  }

  merged_roles_with_sa = {
    for role, sa_lists in local.roles_with_sa :
    role => toset(flatten([for i in toset(sa_lists) : i]...))
  }

  sa_emails = {
    for idx, sdv_sa in google_service_account.sdv_wi_sa : idx => {
      id            = sdv_sa.id
      sa_account_id = local.sdv_sas[idx].account_id
      email         = sdv_sa.email
    }
  }

  #   sdv_sas_with_roles = flatten([
  #     for idx, sdv_sa in google_service_account.sdv_wi_sa : [
  #       for role in local.sdv_sas[idx].roles : {
  #         members            = members + [sdv_sa.email]
  #         sa_account_id      = local.sdv_sas[idx].account_id
  #         service_account_id = sdv_sa.id
  #         email              = sdv_sa.email
  #         role               = role
  #       }
  #     ]
  #   ])


}

# resource "terraform_data" "source" {
#   input = local.merged_roles_with_sa
# }

# resource "terraform_data" "source2" {
#   input = local.sa_emails
# }


# resource "terraform_data" "destination" {
#   lifecycle {
#     replace_triggered_by = [
#       terraform_data.source
#     ]
#   }
# }


# resource "google_service_account_iam_binding" "sdv_wi_sa_wi_users" {
#   for_each = google_service_account.sdv_wi_sa

#   service_account_id = each.value.id

#   role = "roles/iam.workloadIdentityUser"

#   members = [
#     "serviceAccount:${data.google_project.project.project_id}.svc.id.goog[${each.value.gke_ns}/${each.value.gke_sa}]",
#   ]

#   depends_on = [
#     google_service_account.sdv_wi_sa
#   ]
# }


resource "google_service_account_iam_binding" "sdv_wi_sa_wi_users" {
  for_each = { for idx, sdv_sa in google_service_account.sdv_wi_sa : idx => sdv_sa }

  service_account_id = each.value.id

  role = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${data.google_project.project.project_id}.svc.id.goog[${local.sdv_sas[each.key].gke_ns}/${local.sdv_sas[each.key].gke_sa}]",
  ]

  depends_on = [
    google_service_account.sdv_wi_sa
  ]
}

# resource "google_project_iam_binding" "sdv_wi_sa_iam" {
#   project = data.google_project.project.project_id

#   for_each = local.sdv_sas_by_role

#   role = each.key

#   members = [
#     for sa in each.value : "serviceAccount:${google_service_account.sdv_wi_sa[sa.account_id].email}"
#   ]

#   depends_on = [
#     google_service_account.sdv_wi_sa
#   ]
# }


# resource "google_service_account" "sdv_wi_sa" {
#   for_each = { for idx, sdv_sa in local.sdv_sas : idx => sdv_sa }

#   project      = data.google_project.project.project_id
#   account_id   = each.value.account_id
#   display_name = each.value.display_name
#   description  = each.value.description
# }

# resource "google_service_account_iam_binding" "sdv_wi_sa_wi_users" {
#   for_each = { for idx, sdv_sa in google_service_account.sdv_wi_sa : idx => sdv_sa }

#   service_account_id = each.value.id

#   role = "roles/iam.workloadIdentityUser"

#   members = [
#     "serviceAccount:${data.google_project.project.project_id}.svc.id.goog[${local.sdv_sas[each.key].gke_ns}/${local.sdv_sas[each.key].gke_sa}]",
#   ]

#   depends_on = [
#     google_service_account.sdv_wi_sa
#   ]
# }

# locals {
#   members = map()
#   sdv_sas_with_roles = flatten([
#     for idx, sdv_sa in google_service_account.sdv_wi_sa : [
#       for role in local.sdv_sas[idx].roles : {
#         members            = members + [sdv_sa.email]
#         sa_account_id      = local.sdv_sas[idx].account_id
#         service_account_id = sdv_sa.id
#         email              = sdv_sa.email
#         role               = role
#       }
#     ]
#   ])
# }

# resource "google_project_iam_binding" "sdv_wi_sa_iam" {
#   project = data.google_project.project.project_id

#   for_each = { for idx, sdv_sa_role in local.sdv_sas_with_roles : "${sdv_sa_role.sa_account_id}_${sdv_sa_role.role}" => sdv_sa_role }

#   role = each.value.role

#   members = [
#     "serviceAccount:${each.value.email}",
#   ]

#   depends_on = [
#     google_service_account.sdv_wi_sa
#   ]
# }
