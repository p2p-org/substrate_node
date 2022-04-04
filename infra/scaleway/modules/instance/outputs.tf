output "out_name" {
  value = scaleway_instance_server.instance.name
}

output "out_ext_ip" {
  value = scaleway_instance_server.instance.public_ip
}

output "out_int_ip" {
  value = scaleway_instance_server.instance.private_ip
}
