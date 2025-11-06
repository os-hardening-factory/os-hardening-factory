# ---------------------------------------------------------------------------
# Ubuntu Variables (Enterprise Naming Standard)
# ---------------------------------------------------------------------------

variable "base_image" {
  description = "Base Docker image"
  type        = string
  default     = "ubuntu:22.04"
}

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

variable "image_name" {
  description = "Full enterprise image name"
  type        = string
  default     = "ubuntu-22.04-cis1.4-hardening-manual"
}

variable "cis_profile" {
  type    = string
  default = "cis1.0"
  description = "CIS hardening profile applied to this build."
}

variable "enterprise_tag" {
  type        = string
  default     = "none"
  description = "Enterprise-level tag such as eks-1.32-intuit-1"
}

variable "description" {
  type        = string
  default     = "no description provided"
  description = "Human-readable build description (e.g., eks-1.32-intuit-1 built using source AMI ami-xxxxx)."
}

variable "source_ami" {
  type        = string
  default     = "ami-UNKNOWN"
  description = "Source AMI or base image used to create this hardened image."
}