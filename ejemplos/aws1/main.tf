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

resource "aws_security_group" "reglas_red_ivan" {
  name        = "reglas-ivan"
  description = "Reglas de red de Ivan"

  ingress {    
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {    
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


resource "aws_instance" "mi-maquina-ivan" {
    ami           = "ami-05573edad5dd1a926"
    instance_type = "t2.micro"
    key_name      = aws_key_pair.claves_aws.key_name
    
    tags = {
        Name = "MaquinaIvan"
    }
    
    security_groups = [
        aws_security_group.reglas_red_ivan.name
    ]
    
    connection {
        type         = "ssh"
        host         = self.public_ip
        user         = "ubuntu"
        private_key  = tls_private_key.clave_privada.private_key_pem
        port         = 22
    }
    
    provisioner "remote-exec" {
        inline = [ "docker run -p 8080:8080 -d bitnami/tomcat" ]
    }
}

output "mi-clave-privada" {
    value = tls_private_key.clave_privada.private_key_pem
}
output "mi-clave-publica" {
    value = tls_private_key.clave_privada.public_key_pem
}
output "ip_tomcat" {
    value = aws_instance.mi-maquina-ivan.public_ip
}
output "dns_tomcat" {
    value = aws_instance.mi-maquina-ivan.public_dns
}