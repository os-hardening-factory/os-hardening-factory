# Base container image
variable "base_image" {
  type        = string
  default     = "ubuntu:22.04"
  description = "Base container image used for hardened Ubuntu image build."
}

# CIS profile applied
variable "cis_profile" {
  type        = string
  default     = "cis1.0"
  description = "CIS hardening profile applied during build."
}

# OS version for tagging
variable "ubuntu_version" {
  type        = string
  default     = "22.04"
  description = "Ubuntu OS version used in the build (used for labeling)."
}

# Build date (YYYYMMDD)
variable "build_date" {
  type        = string
  default     = "unknown"
  description = "Build date (injected dynamically from pipeline)."
}

# Build time (HHMMSS)
variable "build_time" {
  type        = string
  default     = "unknown"
  description = "Build time (injected dynamically from pipeline)."
}

# Git commit short SHA
variable "git_commit" {
  type        = string
  default     = "manual"
  description = "Git commit hash from source repository."
}

# Enterprise tag (e.g. ubuntu-22.04-intuit-1)
variable "enterprise_tag" {
  type        = string
  default     = "none"
  description = "Enterprise tag format: {vendor}-{version}-intuit-{iteration}"
}

# Source AMI or base image (for audit)
variable "source_ami" {
  type        = string
  default     = "ami-UNKNOWN"
  description = "Source AMI or container image used for this hardened image."
}

# Human-readable build description
variable "description" {
  type        = string
  default     = "no description provided"
  description = "Human-readable description, e.g. ubuntu-22.04-intuit-1 built using source AMI ami-xxxxx."
}

# Internal Packer image name
variable "image_name" {
  type        = string
  default     = "ubuntu-cis-hardening"
  description = "Internal image name used during build."
}
