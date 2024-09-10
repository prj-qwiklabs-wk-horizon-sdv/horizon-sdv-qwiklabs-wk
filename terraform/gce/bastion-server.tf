

resource "google_service_account" "vm_sa" {
  project      = var.project_id
  account_id   = var.bastion_host_sa
  display_name = "Service Account for VM"
}

# A testing VM to allow OS Login + IAP tunneling.
module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 11.0"

  project_id   = var.project_id
  machine_type = "n1-standard-1"
  subnetwork   = var.network_subnet_name
  service_account = {
    email  = google_service_account.vm_sa.email
    scopes = ["cloud-platform"]
  }
  metadata = {
    enable-oslogin = "TRUE"
  }
  source_image = "projects/debian-cloud/global/images/debian-12-bookworm-v20240815"
}

resource "google_compute_instance_from_template" "vm" {
  name    = var.bastion_host_name
  project = var.project_id
  zone    = var.project_zone
  network_interface {
    subnetwork = var.network_subnet_name
  }
  source_instance_template = module.instance_template.self_link
}

# Additional OS login IAM bindings.
# https://cloud.google.com/compute/docs/instances/managing-instance-access#granting_os_login_iam_roles
resource "google_service_account_iam_binding" "sa_user" {
  service_account_id = google_service_account.vm_sa.id
  role               = "roles/iam.serviceAccountUser"
  members            = var.bastion_host_members
}

resource "google_project_iam_member" "os_login_bindings" {
  for_each = toset(var.bastion_host_members)
  project  = var.project_id
  role     = "roles/compute.osAdminLogin"
  member   = each.key
}

module "iap_tunneling" {
  source  = "terraform-google-modules/bastion-host/google//modules/iap-tunneling"
  version = "~> 6.0"

  fw_name_allow_ssh_from_iap = "bastion-allow-ssh-from-iap-to-tunnel"
  project                    = var.project_id
  network                    = var.vpc_network_name
  service_accounts           = [google_service_account.vm_sa.email]
  instances = [{
    name = google_compute_instance_from_template.vm.name
    zone = var.project_zone
  }]
  members = var.bastion_host_members
}

#
# Allows the bastion host SA to manage the GKE cluster
#
resource "google_project_iam_binding" "container-admin-iam" {
  project = var.project_id
  role    = "roles/container.admin"
  members = [
    "serviceAccount:${google_service_account.vm_sa.email}",
  ]
}
