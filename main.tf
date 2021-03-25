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
      "docker-compose up -d debezium",
      "wget --retry-connrefused --retry-on-http-error=404 --tries=10 --wait=4 --spider localhost:8083"
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

resource "null_resource" "setup-tables" {
  depends_on = [digitalocean_droplet.postgres]

  connection {
    type        = "ssh"
    user        = "root"
    host        = digitalocean_droplet.postgres.ipv4_address
    private_key = var.do_private_key
  }

  provisioner "file" {
    source = "setup.sql"
    destination = "setup.sql"
  }

  provisioner "remote-exec" {
    inline = [
      "docker-compose exec -T postgres psql -U debezium < setup.sql"
    ]
  }
}

resource "null_resource" "setup-debezium" {
  depends_on = [
    digitalocean_droplet.postgres,
    digitalocean_droplet.debezium,
  ]

  connection {
    type        = "ssh"
    user        = "root"
    host        = digitalocean_droplet.debezium.ipv4_address
    private_key = var.do_private_key
  }

  provisioner "file" {
    source = "connector.json"
    destination = "connector.json.template"
  }

  provisioner "remote-exec" {
    inline = [
      "sed 's/PGHOST/${digitalocean_droplet.postgres.ipv4_address_private}/' connector.json.template > connector.json",
      "curl -X POST -H 'Accept: application/json' -H 'Content-Type: application/json' localhost:8083/connectors/ -d @connector.json | jq"
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

