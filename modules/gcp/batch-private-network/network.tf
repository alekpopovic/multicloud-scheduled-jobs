resource "google_compute_network" "this" {
  project                 = var.project_id
  name                    = local.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "this" {
  project                  = var.project_id
  region                   = var.region
  name                     = local.subnet_name
  network                  = google_compute_network.this.id
  ip_cidr_range            = var.ip_cidr_range
  private_ip_google_access = true
}

resource "google_compute_router" "this" {
  count = var.create_cloud_nat ? 1 : 0

  project = var.project_id
  region  = var.region
  name    = local.router_name
  network = google_compute_network.this.id
}

resource "google_compute_router_nat" "this" {
  count = var.create_cloud_nat ? 1 : 0

  project                            = var.project_id
  region                             = var.region
  name                               = local.nat_name
  router                             = google_compute_router.this[0].name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
