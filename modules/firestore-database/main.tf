# Create app-specific collection in the existing (default) database
resource "google_firestore_document" "initial_collection" {
  project     = var.project
  collection  = var.collection
  document_id = "init"
  fields      = jsonencode({ "initialized" = { "booleanValue" = true } })
}