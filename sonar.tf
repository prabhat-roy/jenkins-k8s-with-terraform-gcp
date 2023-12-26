
# Create a single Compute Engine instance
resource "google_compute_instance" "sonar" {
  name         = "sonar"
  machine_type = var.vm_type
  zone         = var.zone
  tags         = ["sonar"]
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
      nat_ip = google_compute_address.sonar.address
    }
  }
}
/*
resource "null_resource" "sonar" {
  connection {
    type        = "ssh"
    user        = var.user
    private_key = file(var.private-key)
    host        = google_compute_address.sonar.address
  }
  provisioner "file" {
    source      = "sonar.sh"
    destination = "/tmp/sonar.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/sonar.sh",
      "sh /tmp/sonar.sh",
    ]
  }

  depends_on = [
    google_compute_instance.sonar
  ]
}
*/