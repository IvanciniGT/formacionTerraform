terraform { 
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
        }
    }
}

provider docker {
}

resource "docker_container" "contenedor_nginx"{ 
    name = "mi-contenedor-de-nginx"
    image = docker_image.imagen_nginx.latest

    provisioner "local-exec" {
        command = "echo ${self.name}=${self.network_data[0].ip_address} >> inventario.txt"
    }
    
    connection {
        type        = "ssh"
        host        = self.network_data[0].ip_address
        user        = "root"
        password    = "root"
        port        = 22
    }
    provisioner "remote-exec" {
        inline = [
            "echo ${self.name}=${self.network_data[0].ip_address} >> inventario.txt"
            ]
    }
    
    
}

resource "docker_image" "imagen_nginx"{ 
    name = var.imagen_de_contenedor
}




