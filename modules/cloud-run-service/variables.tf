variable "service_name" {
  description = "Name of the Cloud Run service"
  type        = string
}

variable "region" {
  description = "GCP region for the service"
  type        = string
}

variable "container_image" {
  description = "Container image URL for the service"
  type        = string
}