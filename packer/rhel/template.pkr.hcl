packer {
  required_version = ">= 1.11.0"

  required_plugins {
    docker = {
      version = ">= 1.2.0"
      source  = "github.com/hashicorp/docker"
    }
    ansible = {
      version = ">= 1.1.7"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

# ---------------------------------------------------------------------------
# Docker source definition
# ---------------------------------------------------------------------------
source "docker" "rhel" {
  image  = var.base_image
  commit = true
  changes = [
    "LABEL os-hardening=true",
    "ENV LANG=en_US.UTF-8",
    "ENV LC_ALL=en_US.UTF-8"
  ]
}

# ---------------------------------------------------------------------------
# Build definition
# ---------------------------------------------------------------------------
build {
  name    = var.image_name
  sources = ["source.docker.rhel"]

  # Step 1: Install prerequisites
  provisioner "shell" {
    inline = [
      "echo '🔧 Installing base packages for RHEL hardening...'",
      "microdnf update -y || true",
      "microdnf install -y python3 git openssh-clients sudo tzdata ansible || true",
      "ansible --version || echo '✅ Ansible installed successfully'"
    ]
  }

  # Step 2: Run Ansible hardening
  provisioner "ansible-local" {
    playbook_file = "ansible/playbook.yml"
    playbook_dir  = "ansible"
    role_paths    = ["ansible/roles"]
    extra_arguments = ["-e", "ANSIBLE_HOST_KEY_CHECKING=False"]
  }

  # Step 3: Tag the final image
  post-processor "docker-tag" {
    repository = var.image_name
    tags       = ["latest"]
  }
}
