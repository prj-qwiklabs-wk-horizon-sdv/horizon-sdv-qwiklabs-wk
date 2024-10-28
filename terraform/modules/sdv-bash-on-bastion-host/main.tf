
resource "null_resource" "execute_bash_commands" {
  provisioner "local-exec" {
    command = <<EOT
      echo "Executing bash commands..."
      echo "Creating a directory..."
      mkdir -p /tmp/my_directory
      echo "Directory created."
      echo "Listing files in the directory..."
      ls -la /tmp/my_directory
      echo "All commands executed."
    EOT
  }
}
