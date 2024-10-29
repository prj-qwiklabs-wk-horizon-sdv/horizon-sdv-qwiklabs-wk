

resource "null_resource" "execute_commands_on_bastion" {
   triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
      gcloud compute ssh sdv-bastion-host --zone=europe-west1-d --command="
        echo 'Executing commands on the bastion host...'
        touch ~/terraform-log.log
        echo $(datetime) >> ~/terraform-log.log
      "
    EOT
  }
}
