# Variables specific to the BJJGameBuilder app deployment
variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "optcl-lightweight-apps"
}

variable "region" {
  description = "GCP region for deployment"
  type        = string
  default     = "us-central1"
}