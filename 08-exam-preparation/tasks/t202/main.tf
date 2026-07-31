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
    token   = "eyJjbGllbnRfbmFtZSI6InRlcnJhZm9ybS1jbGllbnQiLCJmaW5nZXJwcmludCI6Ijc5MzU4MjdhN2Q4ODk2NmJhMWI5MmYxZmEyMTcxMzY1MDhmMTViZjhiYThiZmZkYmFmMTBiNzRkZjhmNzI2NzciLCJhZGRyZXNzZXMiOlsiMTAuMC4yLjE1Ojg0NDQiLCJbZmQxNzo2MjVjOmYwMzc6MjphMDA6MjdmZjpmZThlOjE3NjJdOjg0NDQiLCIxOTIuMTY4Ljk5LjIwMjo4NDQ0IiwiMTAuMjEuMTI5LjE6ODQ0NCIsIjEwLjIzLjE5LjE6ODQ0NCIsIltmZDQyOjY5ZDI6YTNmMzpjZTg5OjoxXTo4NDQ0Il0sInNlY3JldCI6ImU4NjQzN2IxNzk2YWNhYzcwM2IxMTVmNGRjNjJlNDg4MTQ5OTY2YmI2ZjVlMDQ3NjRhYzQ3MjA1Zjg3OWRmYjgiLCJleHBpcmVzX2F0IjoiMDAwMS0wMS0wMVQwMDowMDowMFoifQ=="
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
timezone: Europe/Sofia
EOF
}

# LXC 1
resource "incus_instance" "t202-1" {
  name  = "t202-1"
  image = "images:debian/13/cloud"

  config = {
    "boot.autostart" = true
    "user.user-data" = local.cloud-init-config
  }

  device {
    name = "ssh"
    type = "proxy"
    properties = {
      listen  = "tcp:0.0.0.0:10202"
      connect = "tcp:127.0.0.1:22"
    }
  }

  device {
    name = "http"
    type = "proxy"
    properties = {
      listen  = "tcp:0.0.0.0:20202"
      connect = "tcp:127.0.0.1:80"
    }
  }
}

# LXC 2
resource "incus_instance" "t202-2" {
  name  = "t202-2"
  image = "images:debian/13/cloud"

  config = {
    "boot.autostart" = true
    "user.user-data" = local.cloud-init-config
  }

  device {
    name = "ssh"
    type = "proxy"
    properties = {
      listen  = "tcp:0.0.0.0:11202"
      connect = "tcp:127.0.0.1:22"
    }
  }
}