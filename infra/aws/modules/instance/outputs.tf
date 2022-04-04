output "out_name" {
  value = aws_instance.instance.tags.Name
}

output "out_ext_ip" {
  value = aws_instance.instance.public_ip
}

output "out_int_ip" {
  value = aws_instance.instance.private_ip
}
