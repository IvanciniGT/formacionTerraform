variable "nombre_vpc" {
    description = "Este es el nombre de la VPC"
    type = string
}
variable "cidr_vpc" {
    description = "CIDR de la CPV"
    type = string
}
variable "instance_tenancy" {
    description = "Si quiero infra propia para la VPC."
    type = string
    default = "default"
}