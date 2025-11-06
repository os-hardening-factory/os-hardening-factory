packer {
  required_plugins {
    docker = {
      version = ">=1.0.8"
      source  = "github.com/hashicorp/docker"
    }
    ansible = {
      version = ">=1.1.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

# --- Source configuration ---
source "docker" "amazonlinux" {
  image  = "amazonlinux:latest"
  commit = true
}

# --- Build definition ---
build {
  name    = "amazonlinux-hardened"
  sources = ["source.docker.amazonlinux"]

  provisioner "ansible" {
    playbook_file = "./packer/amazonlinux/ansible/playbook.yml"
  }

  post-processor "docker-tag" {
    repository = "661539128717.dkr.ecr.ap-south-1.amazonaws.com/hardened-amazonlinux"
    tags       = [var.local_tag]
  }
}

# --- Variable declaration ---
variable "local_tag" {
  type        = string
  description = "Tag for the hardened image version"
  default     = "latest"
}
