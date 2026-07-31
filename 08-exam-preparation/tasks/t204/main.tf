terraform {
  required_providers {
    incus = {
      source = "lxc/incus"
    }
  }
}

provider "incus" {
  generate_client_certificates = true
  accept_remote_certificate    = true
  default_remote               = "incus"
  remote {
    name    = "incus"
    address = "https://192.168.99.202:8444"
    token   = "eyJjbGllbnRfbmFtZSI6InRlcnJhZm9ybS1jbGllbnQiLCJmaW5nZXJwcmludCI6IjhjMTBiZGIwMTA5ZmJmOGEwNGE3NzA2ZmQ2YTAzM2Q2OGExNzk3MzdlZDM1OWY5OWI4M2VhYzUwYmM0NmU0MWMiLCJhZGRyZXNzZXMiOlsiMTAuMC4yLjE1Ojg0NDQiLCJbZmQxNzo2MjVjOmYwMzc6MjphMDA6MjdmZjpmZThlOjE3NjJdOjg0NDQiLCIxOTIuMTY4Ljk5LjIwMjo4NDQ0IiwiMTAuMzIuNzAuMTo4NDQ0IiwiMTAuMTg1LjE3Ny4xOjg0NDQiLCJbZmQ0MjphMzg5OmExNmI6N2M2Nzo6MV06ODQ0NCJdLCJzZWNyZXQiOiI0ODk1MDRiMzY2ZTE5ZmMyZjI1Njg4YThmYWM2NjY2MmVjMmYyOGI1MmNkY2FiYzlmMjA2OGM3ZGNhYzFkNWIyIiwiZXhwaXJlc19hdCI6IjAwMDEtMDEtMDFUMDA6MDA6MDBaIn0="
  }
}

locals {
  cloud-init-config = <<EOF
#cloud-config
disable_root: 0
ssh_authorized_keys:
  - ${file("~/.ssh/id_rsa.pub")}
package_upgrade: true
packages:
  - openssh-server
runcmd:
  - systemctl enable --now sshd
timezone: Europe/Sofia
EOF
}

# LXC 1 - Fedora
resource "incus_instance" "t204-1" {
  name  = "t204-1"
  image = "images:fedora/44/cloud"

  config = {
    "boot.autostart" = true
    "user.user-data" = local.cloud-init-config
  }

  device {
    name = "ssh"
    type = "proxy"
    properties = {
      listen  = "tcp:0.0.0.0:10204"
      connect = "tcp:127.0.0.1:22"
    }
  }

  device {
    name = "http"
    type = "proxy"
    properties = {
      listen  = "tcp:0.0.0.0:20204"
      connect = "tcp:127.0.0.1:80"
    }
  }
}

# LXC 2 - Debian
resource "incus_instance" "t204-2" {
  name  = "t204-2"
  image = "images:debian/13/cloud"

  config = {
    "boot.autostart" = true
    "user.user-data" = local.cloud-init-config
  }

  device {
    name = "ssh"
    type = "proxy"
    properties = {
      listen  = "tcp:0.0.0.0:11204"
      connect = "tcp:127.0.0.1:22"
    }
  }

  device {
    name = "http"
    type = "proxy"
    properties = {
      listen  = "tcp:0.0.0.0:21204"
      connect = "tcp:127.0.0.1:80"
    }
  }
}

output "t204-1-ip" {
  value = incus_instance.t204-1.ipv4_address
}

output "t204-2-ip" {
  value = incus_instance.t204-2.ipv4_address
}