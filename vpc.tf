resource "google_compute_network" "vpc" {
  name          =  "tf-${var.yourname}-${var.env}-vpc"
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
}

resource "google_compute_firewall" "allow-internal" {
  name    = "tf-${var.yourname}-${var.env}-fw-allow-internal"
  network = google_compute_network.vpc.name
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  source_ranges = [
    var.private_subnet
  ]
}

resource "google_compute_firewall" "allow-rs-ports" {
  name    = "tf-${var.yourname}-${var.env}-fw-allow-rs-ports"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["10000-19999", "8443", "8001", "8070", "8071", "9081", "9443", "8080", "443", "22"]
    # https://docs.redislabs.com/latest/rs/administering/designing-production/networking/port-configurations/?s=port
  }
  allow {
    protocol = "udp"
    ports    = ["53", "5353"]
  }
  source_ranges = [
    var.allIPAddresses
  ]
}

resource "google_compute_subnetwork" "subnet" {
  name          =  "tf-${var.yourname}-${var.env}-network"
  ip_cidr_range = var.private_subnet
  network       = google_compute_network.vpc.id
  region        = var.region_name
}