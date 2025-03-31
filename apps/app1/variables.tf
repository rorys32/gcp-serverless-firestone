variable "project_id" {
  description = "The GCP project ID (from root)"
  type        = string
  default     = "cs-poc-tp17yolgfvyfmwfyqilqcnq"
}

variable "region" {
  description = "The GCP region (from root)"
  type        = string
  default     = "us-central1"
}

variable "app_name" {
  description = "Name of the app service"
  type        = string
  default     = "app1"
}

variable "app_source_path" {
  description = "Local path to the app source repo"
  type        = string
  default     = "../../../BJJGameBuilder"
}