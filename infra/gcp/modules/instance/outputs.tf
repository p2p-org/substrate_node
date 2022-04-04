output "out_name" {
  value = google_compute_instance.instance.name
}

output "out_ext_ip" {
  value = google_compute_instance.instance.network_interface.0.access_config.0.nat_ip
}

output "out_int_ip" {
  value = google_compute_instance.instance.network_interface.0.network_ip
}
