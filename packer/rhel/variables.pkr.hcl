variable "base_image" {
  type        = string
  description = "Base RHEL or UBI image to harden"
  default     = "registry.access.redhat.com/ubi9/ubi:latest"
}

variable "image_name" {
  type        = string
  description = "Final hardened image name"
  default     = "rhel-9-cis1.5-hardening-test"
}

variable "timestamp" {
  type        = string
  description = "Build timestamp injected from workflow"
  default     = "20251106"
}
