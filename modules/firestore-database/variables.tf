# Variables for the Firestore module
variable "project" {
  description = "The GCP project ID"
  type        = string
}

variable "location_id" {
  description = "GCP region for Firestore"
  type        = string
}

variable "collection" {
  description = "Name of the initial Firestore collection"
  type        = string
}