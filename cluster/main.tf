
variable "key_name" {}
variable "ami_id" {}
variable "instance_type" {}
variable "security_group_id" {}
variable "device_name" {}
variable "volume_type" {}
variable "volume_size" {}
variable "os_username" {}
variable "private_key_file_name" {}
variable "domain_name" {}
variable "hostname" {}
variable "vault_version" {}
variable "cert_email" {}


# resource "null_resource" "terraform-debug" {
#   provisioner "local-exec" {
#     command = "echo $VARIABLE1 >> debug.txt"
#
#     environment = {
#         VARIABLE1 = jsonencode("${path.module}/${var.private_key_file_name}")
#     }
#   }
# }


resource "aws_instance" "ubuntu" {
      key_name      = "${var.key_name}"
      ami           = "${var.ami_id}"

      instance_type = "${var.instance_type}"

      tags = {
              Name = "ubuntu"
        }

      vpc_security_group_ids = [
              "${var.security_group_id}"
        ]

      ebs_block_device {
          device_name = "${var.device_name}"
          volume_type = "${var.volume_type}"
          volume_size = "${var.volume_size}"
        }


      connection {
          type        = "ssh"
          user        = "${var.os_username}"
          private_key = file("${path.module}/${var.private_key_file_name}")
          host        = self.public_ip
        }

      provisioner "file" {
          destination = "/home/ubuntu/set-up-vault-ubuntu.sh"
          content     = templatefile("${path.module}/set-up-vault-ubuntu.sh.tftpl", {
            domain_name           = "${var.domain_name}",
            eip                   = self.public_ip,
            hostname              = "${var.hostname}",
            vault_version         = "${var.vault_version}",
            cert_email            = "${var.cert_email}"
        })
      }

      provisioner "file" {
            destination = "/home/ubuntu/vault.service"
            source      = "${path.module}/vault.service"
      }

      provisioner "file" {
            destination = "/home/ubuntu/vault.hcl"
            source      = "${path.module}/vault.hcl"
      }

}


output "instance_id" {
  value = aws_instance.ubuntu.id
}
