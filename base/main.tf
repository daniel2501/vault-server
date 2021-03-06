variable "public_key_file_name" {}

resource "aws_key_pair" "vault" {
    key_name   = "vault"
    public_key = file(var.public_key_file_name)
}

# Break off security group into its own module.
# Use for loop to process yaml config.
resource "aws_security_group" "vault" {
    name        = "vault-security-group"
    description = "Allow HTTP, HTTPS and SSH traffic"

      ingress {
            description = "SSH"
            from_port   = 22
            to_port     = 22
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]

      }

      ingress {
            description = "HTTPS"
            from_port   = 443
            to_port     = 443
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]

      }

      ingress {
            description = "HTTP"
            from_port   = 80
            to_port     = 80
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]

      }

      ingress {
            description = "WEB"
            from_port   = 8080
            to_port     = 8080
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]

      }

      ingress {
            description = "VAULT"
            from_port   = 8200
            to_port     = 8200
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]

      }

      egress {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = ["0.0.0.0/0"]

      }

      tags = {
            Name = "terraform"
      }

}


output "key_name" {
  value = aws_key_pair.vault.key_name
}

output "security_group_id" {
  value = aws_security_group.vault.id
}
