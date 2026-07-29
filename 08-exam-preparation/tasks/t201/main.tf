terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {
  host = "tcp://192.168.99.201:2375"
}

resource "docker_network" "net-docker" {
  name = "t201-net"
}

resource "docker_image" "t201-web-img" {
  name = "t201-web-img"
  build {
    context    = "/home/vagrant/tasks/t201"
    dockerfile = "Dockerfile.web.embedded"
    tag        = ["t201-web-img:latest"]
  }
}

resource "docker_image" "t201-db-img" {
  name = "t201-db-img"
  build {
    context    = "/home/vagrant/tasks/t201"
    dockerfile = "Dockerfile.db"
    tag        = ["t201-db-img:latest"]
  }
}

resource "docker_container" "t201-web-cnt" {
  name  = "web"
  image = docker_image.t201-web-img.image_id
  ports {
    internal = 80
    external = 20201
  }
  networks_advanced {
    name = "t201-net"
  }
}

resource "docker_container" "t201-db-cnt" {
  name  = "db"
  image = docker_image.t201-db-img.image_id
  env   = ["MARIADB_ROOT_PASSWORD=vagrant"]
  networks_advanced {
    name = "t201-net"
  }
}