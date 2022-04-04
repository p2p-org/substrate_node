module "instance" {
  source             = "./modules/instance/"

  for_each = {
    for item in local.config : item.instance_name => item
  }

  zone               = each.value.zone
  region             = each.value.region
  type               = each.value.type

  instance_name      = each.key
  instance_type      = each.value.instance_type

  snapshot_name      = var.snapshot_name

  boot_disk_size     = each.value.boot_disk_size
  boot_disk_image    = each.value.boot_disk_image
  boot_disk_type     = each.value.boot_disk_type

  extended_disk_size = each.value.extended_disk_size
  extended_disk_name = each.value.extended_disk_name
  extended_disk_type = each.value.extended_disk_type

  subnet_id          = try(aws_subnet.main[each.value.zone].id, null)
  firewall           = try(local.firewalls[each.value.type], null)
  
  ebs_optimized      = each.value.ebs_optimized
  ebs_encrypted      = each.value.ebs_encrypted

  ssh_user           = local.ssh_user
  ssh_public_keys    = local.ssh_public_keys
}

module "ansible_inventory" {
  source             = "./modules/ansible_inventory/"
  inventory_path     = var.inventory_path
  instances          = local.instances
  module             = module.instance
  prefix             = local.prefix
  project            = local.project
  regions            = local.regions
  disks              = local.disks
  vars               = local.vars
  vars_list          = local.vars_list
  vars_nested        = local.vars_nested
}
