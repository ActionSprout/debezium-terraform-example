variable "do_token" {}
variable "do_public_key" {}
variable "do_private_key" {}

terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.6.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_ssh_key" "public_key" {
  name       = "Debezium experiment public key"
  public_key = var.do_public_key
}

resource "digitalocean_droplet" "debezium" {
  name     = "experiment-debezium"
  image    = "docker-20-04"
  region   = "sfo2"
  size     = "s-2vcpu-4gb"
  private_networking = true
  ssh_keys = [digitalocean_ssh_key.public_key.fingerprint]

  tags = ["debezium"]

  connection {
    type        = "ssh"
    user        = "root"
    host        = self.ipv4_address
    private_key = var.do_private_key
  }

  provisioner "file" {
    source = "docker-compose.yml"
    destination = "docker-compose.yml"

  }

  provisioner "remote-exec" {
    inline = [
      "docker-compose up -d debezium"
    ]
  }
}

resource "digitalocean_droplet" "postgres" {
  name     = "experiment-debezium-postgres"
  image    = "docker-20-04"
  region   = "sfo2"
  size     = "s-2vcpu-4gb"
  private_networking = true
  ssh_keys = [digitalocean_ssh_key.public_key.fingerprint]

  tags = ["debezium"]

  connection {
    type        = "ssh"
    user        = "root"
    host        = self.ipv4_address
    private_key = var.do_private_key
  }

  provisioner "file" {
    source = "docker-compose.yml"
    destination = "docker-compose.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "docker-compose up -d postgres"
    ]
  }
}

output "debezium_address" {
  value = digitalocean_droplet.debezium.ipv4_address
}

output "postgres_address" {
  value = digitalocean_droplet.postgres.ipv4_address
}

output "postgres_private_address" {
  value = digitalocean_droplet.postgres.ipv4_address_private
}

