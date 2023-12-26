resource "google_compute_network" "vpc_network" {
  name                    = "custom-mode-network"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "custom_subnet" {
  name          = "india-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "asia-south2"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_firewall" "allow-ssh" {
  name          = "allow-ssh-from-console"
  network       = google_compute_network.vpc_network.id
  source_ranges = ["35.235.240.0/20"]
  allow {
    protocol = "tcp"
    ports    = [22]
  }
}

resource "google_compute_firewall" "allow-jenkins" {
  name          = "allow-jenkins"
  network       = google_compute_network.vpc_network.id
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = [8080]
  }
}
resource "google_compute_firewall" "allow-all" {
  name    = "allow-all"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "all"
    ports    = []
  }
  source_ranges = ["10.0.1.0/24"]
}
