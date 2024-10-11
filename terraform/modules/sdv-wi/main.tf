data "google_project" "project" {}

locals {
  sdv_sas = {
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
      ])
    }
  }
}

resource "google_service_account" "sdv_wi_sa" {
  for_each = { for idx, sdv_sa in local.sdv_sas : idx => sdv_sa }

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
        role               = role
      }
    ]
  ])
}

resource "google_project_iam_binding" "sdv_wi_sa_iam" {
  for_each = { for idx, sdv_sa_role in local.sdv_sas_with_roles : "${sdv_sa_role.sa_account_id}_${sdv_sa_role.role}" => sdv_sa_role }

  project = data.google_project.project.id
  role    = each.value.role

  members = [
    "serviceAccount:${each.value.service_account_id}",
  ]

  depends_on = [
    google_service_account.sdv_wi_sa
  ]

}
