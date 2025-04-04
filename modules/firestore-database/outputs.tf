output "collection_name" {
  description = "Name of the app-specific Firestore collection"
  value       = google_firestore_document.initial_collection.collection
}