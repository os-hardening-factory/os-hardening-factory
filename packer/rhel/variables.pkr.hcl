variable "base_image" {
  type        = string
  description = "Base image to use for building the RHEL hardened image"
  default     = "redhat/ubi9:latest"
}

variable "image_name" {
  type        = string
  description = "Name of the final hardened image"
  default     = "rhel-9-cis1.5-hardening"
}

variable "ansible_playbook" {
  type        = string
  description = "Path to the Ansible playbook"
  default     = "ansible/playbook.yml"
}
