# ---------------------------------------------------------------------------
# RHEL CIS Hardening - Packer Variables
# ---------------------------------------------------------------------------

variable "base_image" {
  description = "The base image to use for RHEL hardening"
  type        = string
  default     = "redhat/ubi9:latest"
}

variable "ansible_playbook" {
  description = "Path to the Ansible playbook for RHEL CIS hardening"
  type        = string
  default     = "ansible/playbook.yml"
}

variable "image_name" {
  description = "The final image name (computed externally, e.g., by workflow)"
  type        = string
}

variable "os_name" {
  description = "Operating System name"
  type        = string
  default     = "rhel"
}

variable "os_version" {
  description = "RHEL major version"
  type        = string
  default     = "9"
}

variable "cis_version" {
  description = "CIS benchmark profile version"
  type        = string
  default     = "1.5"
}
