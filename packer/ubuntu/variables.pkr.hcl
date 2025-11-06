# ---------------------------------------------------------------------------
# Ubuntu Variables (Enterprise Naming Standard)
# ---------------------------------------------------------------------------


variable "os_name" {
  description = "Operating System base name"
  type        = string
  default     = "ubuntu"
}

variable "os_version" {
  description = "Operating System version"
  type        = string
  default     = "22.04"
}

variable "cis_version" {
  description = "CIS Benchmark version"
  type        = string
  default     = "1.4"
}

variable "timestamp" {
  description = "Build timestamp (override via CLI)"
  type        = string
  default     = "manual"
}


# Base image (e.g., ubuntu:22.04)
variable "base_image" {
  type        = string
  default     = "ubuntu:22.04"
  description = "Base container image used for building hardened Ubuntu images."
}

# CIS profile (e.g., cis1.4)
variable "cis_profile" {
  type        = string
  default     = "cis1.0"
  description = "CIS hardening profile applied during build."
}

# OS version for metadata labeling
variable "ubuntu_version" {
  type        = string
  default     = "22.04"
  description = "Ubuntu OS version used in the build (used for tagging and labeling)."
}

# Build date (injected dynamically from pipeline)
variable "build_date" {
  type        = string
  default     = "unknown"
  description = "Date when the image was built."
}

# Git commit hash (injected dynamically from pipeline)
variable "git_commit" {
  type        = string
  default     = "manual"
  description = "Git commit hash of the source code used for this build."
}

# Enterprise tag (e.g., ubuntu-22.04-intuit-1)
variable "enterprise_tag" {
  type        = string
  default     = "none"
  description = "Enterprise tag format: {vendor}-{version}-intuit-{iteration}"
}

# Source AMI used (for traceability)
variable "source_ami" {
  type        = string
  default     = "ami-UNKNOWN"
  description = "Source AMI or base image used to create this hardened image."
}

# Description field (human-readable metadata)
variable "description" {
  type        = string
  default     = "no description provided"
  description = "Human-readable description (e.g., ubuntu-22.04-intuit-1 built using source AMI ami-xxxxx)."
}

# Image name (used internally by packer)
variable "image_name" {
  type        = string
  default     = "ubuntu-cis-hardening"
  description = "Internal image name used during build."
}
