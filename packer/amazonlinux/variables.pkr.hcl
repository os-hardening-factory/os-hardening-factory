variable "image_name" {
  type        = string
  description = "Final name of the hardened Amazon Linux image"
}

variable "base_image" {
  type        = string
  default     = "amazonlinux:2"
  description = "Amazon Linux base image"
}

variable "cis_version" {
  type        = string
  default     = "1.3"
  description = "CIS Benchmark version for Amazon Linux 2"
}
