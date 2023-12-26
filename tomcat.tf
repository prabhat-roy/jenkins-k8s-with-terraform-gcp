
# Create a single Compute Engine instance
resource "google_compute_instance" "tomcat" {
  name         = "tomcat"
  machine_type = var.vm_type
  zone         = var.zone
  tags         = ["tomcat"]
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
      nat_ip = google_compute_address.tomcat.address
    }
  }
}
/*
resource "null_resource" "tomcat" {
  connection {
    type        = "ssh"
    user        = var.user
    private_key = file(var.private-key)
    host        = google_compute_address.tomcat.address
  }
  provisioner "file" {
    source      = "tomcat.sh"
    destination = "/tmp/tomcat.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/tomcat.sh",
      "sh /tmp/tomcat.sh",
    ]
  }

  depends_on = [
    google_compute_instance.tomcat
  ]
}
*/