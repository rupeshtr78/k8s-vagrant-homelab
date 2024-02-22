# Configure Terraform to use the Vagrant provider
provider "vagrant" {
}

# Define variables
variable "ip_nw" {
  type = string
  description = "Network prefix"
  default = "192.168.2."
}

variable "ip_start" {
  type = number
  description = "Starting IP address for nodes"
  default = 175
}

variable "num_worker_nodes" {
  type = number
  description = "Number of worker nodes"
  default = 3
}

# Define the network configuration
resource "network_interface" "network" {
  provisioner "shell" {
    command = <<-EOF
      ip addr show eth0 | grep 'inet addr:' | awk '{print $2}' | cut -d '/' -f 1 > network_interface
    EOF
  }
}

# Define the master node
resource "vagrant_vm" "master" {
  name        = "master-node"
  box         = "bento/ubuntu-22.04"
  box_check_update = true
  boot_timeout = 1200

  # Get network interface from provisioner
  network_interface = file("${path.module}/network_interface")

  # Define network configuration
  network "public_network" {
    bridge = "${data.null_resource.network.provisioner.0.stdout}"
    ip    = "${format("%s%d", var.ip_nw, var.ip_start)}"
  }

  # Set resources
  memory = 16384
  cpus   = 8

  # Provisioning scripts
  provision "shell" {
    inline = <<-SHELL
      apt-get update -y
      echo "${var.ip_nw}${var.ip_start} master-node" >> /etc/hosts
    SHELL
  }

  provision "file" {
    source = "scripts/common.sh"
    destination = "/scripts/common.sh"
  }

  provision "file" {
    source = "scripts/master.sh"
    destination = "/scripts/master.sh"
  }

  provision "file" {
    source = "scripts/helm.sh"
    destination = "/scripts/helm.sh"
  }

  # Set timezone (if vagrant-timezone plugin is available)
  if has_plugin("vagrant-timezone") {
    timezone "host"
  }
}

# Define worker nodes (loop)
locals {
  worker_nodes = range(1, var.num_worker_nodes)
}

resource "vagrant_vm" "worker" {
  for_each = local.worker_nodes
  name     = format("worker-node%02d", each.key)

  box         = "bento/ubuntu-22.04"
  box_check_update = true
  boot_timeout = 1200

  # Get network interface from provisioner
  network_interface = file("${path.module}/network_interface")

  # Define network configuration
  network "public_network" {
    bridge = "${data.null_resource.network.provisioner.0.stdout}"
    ip    = format("%s%d", var.ip_nw, var.ip_start + each.key)
  }

  # Set resources
  memory = 8048
  cpus   = 8

  # Provisioning script
  provision "shell" {
    inline = format <<-SHELL
      apt-get update -y
      echo "${var.ip_nw}${var.ip_start + each.key} worker-node%02d" >> /etc/hosts
    SHELL
  }
}


