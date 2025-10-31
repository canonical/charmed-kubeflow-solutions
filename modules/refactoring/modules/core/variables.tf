variable "risk" {
  type        = string
  description = "Value for the risk to be used"
  default     = "stable"

  validation {
    condition     = contains(["stable", "candidate", "beta", "edge"], var.risk)
    error_message = "Valid values for var: risk are (stable, candidate, beta and edge)."
  }
}

variable "admission_webhook" {
  type = object({
    channel = optional(string)
    revision = optional(number)
    name = optional(string, "admission_webhook")
    config = optional(map(string), {})
  })
}
