# currently no officially supported VirtualBox provider for Terraform.
variable "num_worker_nodes" {
  default = 3
}

variable "ip_nw" {
  default = "192.168.2."
}

variable "ip_start" {
  default = 130
}

data "template_file" "script" {
  template = <<-SCRIPT
    apt-get update -y
    echo "$${ip_nw}$${ip_start} master-node" >> /etc/hosts
    for i in $$(seq 1 $${num_worker_nodes}); do
      echo "$${ip_nw}$${(ip_start+i)} worker-node0$$i" >> /etc/hosts
    done
  SCRIPT
  
  vars = {
    ip_nw = "${var.ip_nw}"
    ip_start = "${var.ip_start}"
    num_worker_nodes = "${var.num_worker_nodes}"
  }
}

resource "virtualbox_vm" "master" {
  count     = 1
  name      = "master-node"
  image     = "bento/ubuntu-22.04"
  cpus      = 8
  memory    = "16384 mib"
  script = "${data.template_file.script.rendered}"
}

resource "virtualbox_vm" "workers" {
  count     = var.num_worker_nodes
  name      = "worker-node0${count.index+1}"
  image     = "bento/ubuntu-22.04"
  cpus      = 4
  memory    = "8048 mib"
  script = "${data.template_file.script.rendered}"
}
