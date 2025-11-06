packer {
  required_plugins {
    docker = {
      version = ">=1.0.8"
      source  = "github.com/hashicorp/docker"
    }
    ansible = {
      version = ">=1.0.3"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

source "docker" "${os}" {
  image  = "${os}:latest"
  commit = true
}

build {
  name    = "${os}-hardened"
  sources = ["source.docker.${os}"]

  provisioner "ansible" {
    playbook_file = "./packer/${os}/ansible/playbook.yml"
  }

  post-processor "docker-tag" {
    repository = "661539128717.dkr.ecr.ap-south-1.amazonaws.com/hardened-${os}"
    tag        = "v1.0.0-cis1.4-$(date +%Y%m%d)"
  }
}
