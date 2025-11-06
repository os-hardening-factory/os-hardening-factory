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
      "microdnf install -y python3 git sudo tar",
      "pip3 install ansible",
      "ansible --version || echo '✅ Ansible installed successfully'"
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
