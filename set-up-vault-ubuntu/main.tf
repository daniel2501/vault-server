
variable "os_username" {}
variable "private_key_file_name" {}
variable "eip" {}


resource "null_resource" "set-up-vault-ubuntu" {

    connection {
      type        = "ssh"
      user        = "${var.os_username}"
      private_key = file("${var.private_key_file_name}")
      host        = "${var.eip}"
    }

    provisioner "remote-exec" {
      inline      = [
        "chmod +x /home/ubuntu/set-up-vault-ubuntu.sh",
        "sudo /home/ubuntu/set-up-vault-ubuntu.sh > /home/ubuntu/install-log.log 2>&1"
      ]
    }
 }
