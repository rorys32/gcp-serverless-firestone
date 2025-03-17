# Root-level variables for global configuration
variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "optcl-lightweight-apps"
}

variable "region" {
  description = "The GCP region for deployment"
  type        = string
  default     = "us-central1"
}