# ---------------------------------------------------------------------------
# 🧩 Variables for RHEL CIS Hardening
# ---------------------------------------------------------------------------

# CIS Benchmark version used for compliance
variable "cis_version" {
  type        = string
  description = "CIS benchmark version for this hardening build"
  default     = "1.5"
}

# Simple timestamp using shell injection from workflow
variable "timestamp" {
  type        = string
  description = "Timestamp for image tagging (passed from workflow)"
  default     = "20251106"
}
