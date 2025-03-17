# Main configuration for the GCP provider
provider "google" {
  project = var.project_id
  region  = var.region
}

# Variables defined in variables.tf
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

# Output the project ID for reference
output "project_id" {
  value = var.project_id
}