resource "google_compute_instance" "node1" {
  name         = "tf-${var.yourname}-${var.env}-1"
  machine_type = var.gcp_instance_type // https://gcpinstances.info/?cost_duration=monthly
  // example with minimal 2vcpu 4GB RAM
  // which leaves about 1.4GB for Redis DB
  // machine_type = "custom-2-4096" // https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance
  zone         = "${var.region_name}-b" //TODO
  boot_disk {
    initialize_params {
      image = "ubuntu-minimal-1804-lts"
    }
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/google_compute_engine.pub")}"
    startup-script = templatefile("${path.module}/scripts/instance.sh", {
      cluster_dns = "rscluster.${var.dns_zone_dns_name}",
      node_id  = 1
      node_1_ip   = ""
      RS_release = var.RS_release
      RS_admin = var.RS_admin
      RS_password = random_password.password.result
    })
  }
  network_interface {
    subnetwork = google_compute_subnetwork.subnet.name
    access_config {
      // Ephemeral IP
    }
  }
}

resource "google_compute_instance" "nodeX" {
  count = var.clustersize - 1

  name         = "tf-${var.yourname}-${var.env}-${count.index + 1 + 1}" #+1+1 as we have node1 above
  machine_type = var.gcp_instance_type
  zone         = "${var.region_name}-b" //TODO
  boot_disk {
    initialize_params {
      image = "ubuntu-minimal-1804-lts"
    }
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/google_compute_engine.pub")}"
    startup-script = templatefile("${path.module}/scripts/instance.sh", {
      cluster_dns = "rscluster.${var.dns_zone_dns_name}",
      node_id  = count.index+1+1
      node_1_ip = google_compute_instance.node1.network_interface.0.network_ip
      RS_release = var.RS_release
      RS_admin = var.RS_admin
      RS_password = random_password.password.result
    })
  }
  network_interface {
    subnetwork = google_compute_subnetwork.subnet.name
    access_config {
      // Ephemeral IP
    }
  }
}

resource "google_compute_instance" "memtier_instance" {

  name         = "tf-${var.yourname}-${var.env}-memtier" #+1+1 as we have node1 above
  machine_type = "e2-standard-2"
  zone         = "${var.region_name}-b" //TODO
  boot_disk {
    initialize_params {
      image = "ubuntu-minimal-1804-lts"
    }
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/google_compute_engine.pub")}"
    startup-script = templatefile("${path.module}/scripts/memtier_init.sh",{})
  }
  network_interface {
    subnetwork = google_compute_subnetwork.subnet.name
    access_config {
      // Ephemeral IP
    }
  }
}

resource "random_password" "password" {
  length           = 12
  special          = true
  override_special = "_"
}
