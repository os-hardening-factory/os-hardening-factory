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

# Docker source
source "docker" "ubuntu" {
  image  = var.base_image
  commit = true
  changes = [
    "LABEL maintainer='CloudOps Team'",
    "LABEL os='ubuntu'",
    "LABEL os_version='${var.ubuntu_version}'",
    "LABEL cis_profile='${var.cis_profile}'",
    "LABEL build_date='${var.build_date}'",
    "LABEL git_commit='${var.git_commit}'",
    "LABEL base_image='${var.base_image}'",
    "LABEL source_ami='${var.source_ami}'",
    "LABEL enterprise_tag='${var.enterprise_tag}'",
    "LABEL description='${var.description}'",
    "LABEL tag_format='{vendor}-{version}-intuit-{iteration}'",
    "LABEL builder='github-actions'",
    "ENV DEBIAN_FRONTEND=noninteractive"
  ]
}



# Build
build {
  name    = var.image_name
  sources = ["source.docker.ubuntu"]

  # Install deps + ansible inside container
  provisioner "shell" {
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "ln -fs /usr/share/zoneinfo/UTC /etc/localtime",
      "apt-get update -y",
      "apt-get install -y tzdata python3 python3-apt git curl sudo ansible",
      "dpkg-reconfigure --frontend noninteractive tzdata",
      "ansible --version || echo '✅ Ansible installed successfully'",
      "apt-get clean && rm -rf /var/lib/apt/lists/*"
    ]
  }

  # Run CIS playbook
  provisioner "ansible-local" {
    playbook_file = "${path.root}/ansible/playbook.yml"
    playbook_dir  = "${path.root}/ansible"
    role_paths    = ["${path.root}/ansible/roles"]
    extra_arguments = [
      "-e", "ANSIBLE_HOST_KEY_CHECKING=False",
      "--extra-vars", "ansible_python_interpreter=/usr/bin/python3"
    ]
  }

  # ✅ Clean tag logic: repository is the full enterprise name, tag is simple
  post-processor "docker-tag" {
    repository = var.image_name
    tags       = ["latest"]
  }
}
