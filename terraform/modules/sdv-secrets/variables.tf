
variable "location" {
  description = "Define the secret replication location"
  type        = string
}

variable "gh_app_id" {
  description = "The gh_app_id secret"
  type        = string
}

variable "gh_installation_id" {
  description = "The gh_installation_id secret"
  type        = string
}


# GITHUB/SECRET/ORG/APP_AGBG_ASG_TERRAFORM_FETCHER_PRIVATE_KEY -> not sync'ed to GCP
# GITHUB/SECRET/ENV/GCP_SA -> not sync'ed to GCP
# GITHUB/SECRET/ENV/WIF_PROVIDER -> not sync'ed to GCP

# GITHUB/VAR/ENV/GH_APP_ID -> GCP/SECRET/githubAppID
# GITHUB/VAR/ENV/GH_INSTALLATION_ID -> GCP/SECRET/githubAppInstallationID

# GITHUB/SECRET/ORG/GH_APP_KEY -> GCP/SECRET/githubAppPrivateKey
# GITHUB/SECRET/ENV/ARGOCD_INITIAL_PASSWORD -> GCP/SECRET/argocdInitialPassword
# GITHUB/SECRET/ENV/JENKINS_INITIAL_PASSWORD -> GCP/SECRET/jenkinsInitialPassword
# GITHUB/SECRET/ENV/KEYCLOAK_INITIAL_PASSWORD -> GCP/SECRET/keycloakInitialPassword
# NO_GITHUB_SECRET -> GCP/SECRET/keycloakIdpCredentials

# GKE/NS/argocd/SA/argocd-sa -> GCP/SA/argocd-sa -> GCP/SECRET/githubAppID & GCP/SECRET/githubAppInstallationID & GCP/SECRET/githubAppPrivateKey & GCP/SECRET/argocdInitialPassword
# GKE/NS/jenkins/SA/jenkins-sa -> GCP/SA/jenkins-sa -> GCP/SECRET/githubAppID & GCP/SECRET/githubAppInstallationID & GCP/SECRET/githubAppPrivateKey & GCP/SECRET/jenkinsInitialPassword
# GKE/NS/keycloak/SA/keycloak-sa -> GCP/SA/keycloak-sa -> GCP/SECRET/keycloakInitialPassword & GCP/SECRET/keycloakIdpCredentials

