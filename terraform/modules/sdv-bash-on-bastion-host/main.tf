
data "google_project" "project" {}

resource "terraform_data" "debug_google_project" {
  input = data.google_project.project
}

resource "null_resource" "execute_bash_commands" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "Executing bash commands..."
      gcloud beta compute ssh ${var.bastion_host} --zone=${var.zone} --project=${data.google_project.project.project_id} --command="
      echo 'Executing commands on the bastion host...'
      ${var.command}

    EOT
  }
}
