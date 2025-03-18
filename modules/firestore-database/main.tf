# Sets up Firestore in Native mode
resource "google_firestore_database" "database" {
  project     = var.project
  name        = "(default)"  # Default database name
  location_id = var.location_id
  type        = "FIRESTORE_NATIVE"
}

# Creates a collection (placeholder—app will populate it)
resource "google_firestore_document" "initial_collection" {
  project     = var.project
  collection  = var.collection
  document_id = "init"
  fields      = jsonencode({ "status" = { "stringValue" = "initialized" } })
  depends_on  = [google_firestore_database.database]
}