packer {
  required_plugins {
    docker = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/docker"
    }
    ansible = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

source "docker" "amazonlinux" {
  image  = var.base_image
  commit = true
  changes = [
    "LABEL maintainer='CloudOps Team'",
    "LABEL cis_version='${var.cis_version}'",
    "LABEL os='amazonlinux2'"
  ]
}

build {
  name    = var.image_name
  sources = ["source.docker.amazonlinux"]

  provisioner "shell" {
    inline = [
      "echo '🧩 Prepping system for Ansible provisioning...'",
      "yum install -y python3 sudo dnf-utils || true",
      "python3 --version",
      "echo '✅ System prepared for hardening execution.'"
    ]
  }

  provisioner "ansible-local" {
    playbook_file = "packer/amazonlinux/ansible/playbook.yml"
    playbook_dir  = "packer/amazonlinux/ansible"
    role_paths    = ["packer/amazonlinux/ansible/roles"]
    staging_directory = "/tmp/ansible"
  }
}
