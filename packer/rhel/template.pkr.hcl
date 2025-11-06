packer {
  required_plugins {
    docker = {
      source  = "github.com/hashicorp/docker"
      version = ">= 1.1.2"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = ">= 1.1.4"
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
    "ENV ANSIBLE_HOST_KEY_CHECKING=False",
    "ENV PACKER_BUILD_OS=rhel"
  ]
}

# ---------------------------------------------------------------------------
# Build definition
# ---------------------------------------------------------------------------
build {
  name    = var.image_name
  sources = ["source.docker.rhel"]

  # -------------------------------------------------------------------------
  # Step 1: Install Python and Ansible inside the container
  # -------------------------------------------------------------------------
  provisioner "shell" {
    inline = [
      "if command -v dnf >/dev/null 2>&1; then PKG_MGR=dnf; elif command -v microdnf >/dev/null 2>&1; then PKG_MGR=microdnf; else echo '❌ No supported package manager found' && exit 1; fi",
      "echo '📦 Using package manager:' $PKG_MGR",
      "sudo $PKG_MGR -y update || true",
      "sudo $PKG_MGR -y install python3 git openssh-clients sudo tzdata ansible",
      "sudo $PKG_MGR clean all"
    ]
  }


  # -------------------------------------------------------------------------
  # Step 2: Copy Ansible playbook and roles into container
  # -------------------------------------------------------------------------
  provisioner "file" {
    source      = "${path.root}/ansible"
    destination = "/tmp/ansible"
  }

  # -------------------------------------------------------------------------
  # Step 3: Run CIS hardening playbook
  # -------------------------------------------------------------------------
  provisioner "ansible-local" {
    playbook_file = "packer/rhel/ansible/playbook.yml"
    playbook_dir  = "packer/rhel/ansible"
    role_paths    = ["packer/rhel/ansible/roles"]
    extra_arguments = ["-e", "ANSIBLE_HOST_KEY_CHECKING=False"]
  }

  # -------------------------------------------------------------------------
  # Step 4: Tag final image
  # -------------------------------------------------------------------------
  post-processor "docker-tag" {
    repository = var.image_name
    tags       = ["latest"]
  }
}
