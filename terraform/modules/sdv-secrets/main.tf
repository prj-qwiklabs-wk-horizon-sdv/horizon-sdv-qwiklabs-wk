
locals {
  sdv_secrets = {
    s1 = {
      secret_id = "githubAppID"
      value     = var.gh_app_id
    }
    s2 = {
      secret_id = "githubAppInstallationID"
      value     = var.gh_installation_id
    }
  }
}


resource "google_secret_manager_secret" "sdv_gsms" {
  for_each = { for idx, sdv_sa in local.sdv_secrets : idx => sdv_sa }

  secret_id = each.value.secret_id

  replication {
    user_managed {
      replicas {
        location = var.location
      }
    }
  }
}

resource "google_secret_manager_secret_version" "sdv_gsmsv" {
  for_each    = { for idx, sdv_sa in google_secret_manager_secret.sdv_gsms : idx => sdv_sa }
  secret      = each.value.id
  secret_data = local.sdv_secrets[each.key].value
}
