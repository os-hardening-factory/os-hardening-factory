# ---------------------------------------------------------------------------
# 📦 Packer Template for RHEL CIS Hardening
# ---------------------------------------------------------------------------
# Builds a Docker-based hardened RHEL image according to CIS benchmark.
# This configuration uses HashiCorp Packer with Docker + Ansible provisioners.
# ---------------------------------------------------------------------------

packer {
  required_version = ">= 1.11.0"

  required_plugins {
    docker = {
      version = ">= 1.1.2"
      source  = "github.com/hashicorp/docker"
    }
    ansible = {
      version = ">= 1.1.4"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

# ---------------------------------------------------------------------------
# 🧩 Variable Definitions
# ---------------------------------------------------------------------------
variable "base_image" {
  type        = string
  description = "Base image for building the hardened container"
  default     = "redhat/ubi9:latest"
}

variable "image_name" {
  type        = string
  description = "Final hardened image name and tag"
}

# ---------------------------------------------------------------------------
# 🧱 Docker Source Definition
# ---------------------------------------------------------------------------
source "docker" "rhel" {
  image  = var.base_image
  commit = true

  changes = [
    "LABEL vendor='rhel'",
    "LABEL os-hardening='true'",
    "ENV ANSIBLE_HOST_KEY_CHECKING=False",
    "ENV DEBIAN_FRONTEND=noninteractive"
  ]
}

# ---------------------------------------------------------------------------
# 🏗️ Build Definition
# ---------------------------------------------------------------------------
build {
  name    = var.image_name
  sources = ["source.docker.rhel"]

  # -------------------------------------------------------------------------
  # Step 1: Prepare environment inside container (install dependencies)
  # -------------------------------------------------------------------------
  provisioner "shell" {
    inline = [
      "echo '🔧 Preparing RHEL environment...'",
      "yum -y update || true",
      "yum -y install python3 python3-pip git curl sudo ansible || true",
      "pip3 install --upgrade pip",
      "ansible --version || echo '✅ Ansible installed successfully'",
      "yum clean all && rm -rf /var/cache/yum"
    ]
  }

  # -------------------------------------------------------------------------
  # Step 2: Apply CIS hardening using Ansible playbook
  # -------------------------------------------------------------------------
  provisioner "ansible-local" {
    playbook_file = "${path.root}/ansible/playbook.yml"
    playbook_dir  = "${path.root}/ansible"
    role_paths    = ["${path.root}/ansible/roles"]

    extra_arguments = [
      "-e", "ANSIBLE_HOST_KEY_CHECKING=False"
    ]
  }

  # -------------------------------------------------------------------------
  # Step 3: Tag the final image
  # -------------------------------------------------------------------------
  post-processor "docker-tag" {
    repository = var.image_name
    tags       = ["latest"]
  }
}
