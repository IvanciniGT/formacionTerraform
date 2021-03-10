terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
        tls = {
            source ="hashicorp/tls"
        }
    }
}

provider "tls" {}

provider "aws" {
    region = "eu-west-1"
    profile = "default"
}

resource "tls_private_key" "clave_privada" {
  algorithm   = "RSA"
  rsa_bits    = "4096"
}

resource "aws_key_pair" "claves_aws" {
  key_name   = "mi_clave_ivan"
  public_key = tls_private_key.clave_privada.public_key_openssh
}

resource "aws_instance" "mi-maquina-ivan" {
    ami           = "ami-05573edad5dd1a926"
    instance_type = "t2.micro"
    key_name      = aws_key_pair.claves_aws.key_name
    
    tags = {
        Name = "MaquinaIvan"
    }
    
    connection {
        type         = "ssh"
        host         = self.public_ip
        user         = "ubuntu"
        private_key  = tls_private_key.clave_privada.private_key_pem
    }
    
    provisioner "remote-exec" {
        inline = [ "uname -a" ]
    }
}

output "mi-clave-privada" {
    value = tls_private_key.clave_privada.private_key_pem
}
output "mi-clave-publica" {
    value = tls_private_key.clave_privada.public_key_pem
}