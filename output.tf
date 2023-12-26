
output "jenkins-url" {
  value = join("", ["http://", google_compute_address.jenkins.address, ":", "8080"])
}

output "sonar-ip" {
  value = join("", ["http://", google_compute_address.sonar.address, ":", "9000"])
}

output "nexus-url" {
  value = join("", ["http://", google_compute_address.nexus.address, ":", "8081"])
}

output "tomcat-ip" {
  value = join("", ["http://", google_compute_address.tomcat.address, ":", "8080"])
}


output "wazuh-url" {
  value = join("", ["https://", google_compute_address.wazuh.address, ":", "443"])
}