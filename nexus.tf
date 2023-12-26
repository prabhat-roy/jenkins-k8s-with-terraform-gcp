
# Create a single Compute Engine instance
resource "google_compute_instance" "nexus" {
  name         = "nexus"
  machine_type = var.vm_type
  zone         = var.zone
  tags         = ["nexus"]
  boot_disk {
    initialize_params {
      image = var.vm_image
    }
  }
  metadata = {
    ssh-keys = "${var.user}:${file(var.public-key)}"
  }
  network_interface {
    subnetwork = google_compute_subnetwork.custom_subnet.id
    access_config {
      nat_ip = google_compute_address.nexus.address
    }
  }
}
/*
resource "null_resource" "nexus" {
  connection {
    type        = "ssh"
    user        = var.user
    private_key = file(var.private-key)
    host        = google_compute_address.nexus.address
  }
  provisioner "file" {
    source      = "nexus.sh"
    destination = "/tmp/nexus.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/nexus.sh",
     "sh /tmp/nexus.sh",
    ]
  }

  depends_on = [
    google_compute_instance.nexus
  ]
}
*/