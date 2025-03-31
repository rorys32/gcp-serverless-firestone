variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "cs-poc-tp17yolgfvyfmwfyqilqcnq"
}

variable "region" {
  description = "The GCP region for deployment"
  type        = string
  default     = "us-central1"
}

variable "app_name" {
  description = "Generic name for the deployed app"
  type        = string
  default     = "app1"
}