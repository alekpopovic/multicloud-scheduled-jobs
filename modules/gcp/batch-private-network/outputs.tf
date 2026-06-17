output "network_name" {
  description = "Name of the VPC network."
  value       = google_compute_network.this.name
}

output "network_id" {
  description = "ID of the VPC network."
  value       = google_compute_network.this.id
}

output "network_self_link" {
  description = "Self link of the VPC network."
  value       = google_compute_network.this.self_link
}

output "subnetwork_name" {
  description = "Name of the subnet."
  value       = google_compute_subnetwork.this.name
}

output "subnetwork_id" {
  description = "ID of the subnet."
  value       = google_compute_subnetwork.this.id
}

output "subnetwork_self_link" {
  description = "Self link of the subnet."
  value       = google_compute_subnetwork.this.self_link
}

output "cloud_router_name" {
  description = "Name of the Cloud Router when Cloud NAT is enabled."
  value       = var.create_cloud_nat ? google_compute_router.this[0].name : null
}

output "cloud_nat_name" {
  description = "Name of the Cloud NAT when enabled."
  value       = var.create_cloud_nat ? google_compute_router_nat.this[0].name : null
}
