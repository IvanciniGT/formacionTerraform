# Módulo para la creación de un aVPC, subdereds y demás
terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}
# Variables
# nombre_vpc= Este es el nombre de la VPC
# cidr_vpc= CIDR de la CPV
# instance_tenancy= Si quiero infra propia para la VPC. default

# VPC
resource "aws_vpc" "vpc"{
    # (Required) The CIDR block for the VPC.
    cidr_block  =  var.cidr_vpc
    # (Optional) A tenancy option for instances launched into the VPC. Default is default, which makes your instances shared on the host. Using either of the other options (dedicated or host) costs at least $2/hr.
    instance_tenancy = var.instance_tenancy
    # (Optional) A boolean flag to enable/disable DNS support in the VPC. Defaults true.
    enable_dns_support = true
    # (Optional) A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false.
    enable_dns_hostnames = true
    # (Optional) A map of tags to assign to the resource.
    tags {
        Name = var.nombre_vpc
    }
}

# Subnet 

# Tablas de Ruta
#      Rutas
# Vincular tablas de ruta

# Gateway

# SecurityGroups