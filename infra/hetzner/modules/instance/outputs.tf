output "out_name" {
  value = hcloud_server.instance.name
}

output "out_ext_ip" {
  value = hcloud_server.instance.ipv4_address
}

output "out_int_ip" {
  value = hcloud_server_network.default.ip
}
