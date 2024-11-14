
resource "null_resource" "copy_to_bastion" {
  triggers = {
    always_run = "${timestamp()}"
  }

  for_each = toset(var.files)
  provisioner "local-exec" {
    command = "gcloud compute scp ${each.value} ${var.bastion_host_name}:${var.destination_path}"
  }
}

