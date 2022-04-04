resource "aws_eip" "default" {
  instance = aws_instance.instance.id
  vpc      = true
  tags = {
    Name = var.instance_name
  }
}

resource "aws_ebs_volume" "extended_disk" {
  count                       = var.extended_disk_size > 0 ? 1 : 0
  availability_zone           = var.zone
  type                        = var.boot_disk_type
  size                        = var.extended_disk_size
  encrypted                   = var.ebs_encrypted

  tags = {
    Name = var.instance_name
  }
}

resource "aws_volume_attachment" "default" {
  count                       = var.extended_disk_size > 0 ? 1 : 0
  device_name                 = "/dev/sdh"
  volume_id                   = aws_ebs_volume.extended_disk[0].id
  instance_id                 = aws_instance.instance.id
}

resource "aws_instance" "instance" {
  ami                         = var.boot_disk_image
  instance_type               = var.instance_type
  
  availability_zone           = var.zone
  vpc_security_group_ids      = var.firewall
  associate_public_ip_address = true
  subnet_id                   = var.subnet_id

  ebs_optimized               = var.ebs_optimized

  root_block_device {
    volume_type = var.boot_disk_type
    volume_size = var.boot_disk_size
    encrypted   = var.ebs_encrypted
  }

  tags = {
    Name = var.instance_name
  }

  user_data = <<-EOF
    #!/bin/bash
    echo -e "${join("\n", [for row in var.ssh_public_keys : "${row}"])}" > /home/${var.ssh_user}/.ssh/authorized_keys
    chmod 700 /home/${var.ssh_user}/.ssh
    chmod 644 /home/${var.ssh_user}/.ssh/authorized_keys
  EOF

  lifecycle {
    ignore_changes   = [user_data]
  }

}
