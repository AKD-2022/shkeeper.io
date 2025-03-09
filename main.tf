provider "google" {
  project = "shkeeper-project"  
  region  = "us-central1"
}

resource "google_container_cluster" "primary" {
  name     = "shkeeper-cluster"
  location = "us-central1-a"  # Zonal cluster for simplicity
  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection = false  # Explicitly disable deletion protection
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "default-pool"
  cluster    = google_container_cluster.primary.name
  location   = google_container_cluster.primary.location
  node_count = 1  # Single node for cost savings

  node_config {
    machine_type = "e2-standard-4"  # 4 vCPUs, 16 GB RAM
    preemptible  = true             # Cheaper, terminates after 24 hours
    disk_size_gb = 200              # Matches shkeeper.io requirement
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}
