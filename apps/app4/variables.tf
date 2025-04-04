variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "project_number" {
  type        = string
  description = "GCP Project Number"
}

variable "region" {
  type        = string
  description = "GCP Region"
}

variable "app_name" {
  type        = string
  description = "Application name"
}

variable "app_source_path" {
  type        = string
  description = "Path to app source code"
}

variable "container_image" {
  type        = string
  description = "Docker image URL"
}

variable "container_port" {
  type        = number
  description = "Port the container listens on"
}

variable "env_vars" {
  type        = map(string)
  description = "Environment variables for the container"
  default     = {}
}

variable "backend_type" {
  type        = string
  description = "Backend type (e.g., json, firestore)"
}