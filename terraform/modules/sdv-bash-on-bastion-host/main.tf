
resource "null_resource" "execute_bash_commands" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "Executing bash commands..."

      gcloud beta compute ssh sdv-bastion-host --zone=europe-west1-d --project=sdva-2108202401 --command="
      echo 'Executing commands on the bastion host...'
      touch ~/terraform-log.log
      echo $(date) >> ~/terraform-log.log
      cat ~/terraform-log.log"

    EOT
  }
}
