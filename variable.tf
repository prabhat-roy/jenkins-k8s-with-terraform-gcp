variable "project_id" {
  default = "round-cable-405107"
}
variable "region" {
  default = "asia-south2"
}
variable "zone" {
  default = "asia-south2-c"
}
variable "vm_type" {
  default = "e2-standard-2"
}
variable "vm_image" {
  default = "ubuntu-os-cloud/ubuntu-2204-lts"
}
variable "k8s_image" {
  default = "ubuntu-os-cloud/ubuntu-2004-lts"
}
variable "service_account_email" {
  default = "933437503438-compute@developer.gserviceaccount.com"
}
variable "cred" {
  default = "key.json"
}
variable "private-key" {
  default = "~/.ssh/gcp"
}
variable "public-key" {
  default = "~/.ssh/gcp.pub"
}
variable "user" {
  default = "prabh"
}
