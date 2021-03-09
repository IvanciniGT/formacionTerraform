
output "ip_del_contenedor"{
    value = docker_container.contenedor_nginx.network_data[0].ip_address
}





