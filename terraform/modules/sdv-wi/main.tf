data "google_project" "project" {}

#
# To create new SA that have access from GKE to GC, create a new saN block and
# add the required gke ns and sa as the roles, the terraform blocks bellow 
# will apply it to your project.
#
locals {
  sdv_sas = var.wi_service_accounts
}

resource "google_service_account" "sdv_wi_sa" {
  for_each = { for idx, sdv_sa in local.sdv_sas : idx => sdv_sa }

  project      = data.google_project.project.project_id
  account_id   = each.value.account_id
  display_name = each.value.display_name
  description  = each.value.description
}

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

locals {
  sdv_sas_with_roles = flatten([
    for idx, sdv_sa in google_service_account.sdv_wi_sa : [
      for role in local.sdv_sas[idx].roles : {
        sa_account_id      = local.sdv_sas[idx].account_id
        service_account_id = sdv_sa.id
        email              = sdv_sa.email
        role               = role
      }
    ]
  ])
}

resource "google_project_iam_binding" "sdv_wi_sa_iam" {
  project = data.google_project.project.project_id

  for_each = { for idx, sdv_sa_role in local.sdv_sas_with_roles : "${sdv_sa_role.sa_account_id}_${sdv_sa_role.role}" => sdv_sa_role }

  role = each.value.role

  members = [
    "serviceAccount:${each.value.email}",
  ]

  depends_on = [
    google_service_account.sdv_wi_sa
  ]
}
