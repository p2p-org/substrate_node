resource "local_file" "ansible_inventory" {
  for_each = { 
  for k,v in var.instances : k => v...
  }
  
  content  = templatefile("${path.module}/inventory.tmpl",
  {
    inventory_name  = each.key
    instances       = each.value
    prefix          = var.prefix
    regions         = var.regions
    disks           = var.disks
    module          = var.module
    vars            = var.vars
    vars_list       = var.vars_list
    vars_nested     = var.vars_nested
   })

  filename = "${var.inventory_path}/${var.project}/${var.prefix}-${each.key}.yml"
}
