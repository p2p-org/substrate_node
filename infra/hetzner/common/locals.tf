locals {
  raw_settings = yamldecode(file("config.yml"))

  config = flatten([
     for instance, params in local.raw_settings.instances : [
       for machine, p in params.machines : {
         type                = instance
         instance_name       = machine
         instance_type       = try(p.instance_type, params.instance_type)
         boot_disk_image     = try(p.boot_disk_image, params.boot_disk_image)
         boot_disk_size      = try(p.boot_disk_size, params.boot_disk_size)
         extended_disk_type  = try(p.extended_disk_type, try(params.extended_disk_type, null))
         extended_disk_size  = try(p.extended_disk_size, try(params.extended_disk_size, 0))
         extended_disk_name  = try(p.extended_disk_name, try(params.extended_disk_name, "none"))
         floating_ip         = try(p.floating_ip, try(params.floating_ip, "no"))
         region              = try(p.region, try(params.region, "none"))
         zone                = try(p.zone, try(params.zone, null))
         vars                = try(p.vars, try(params.vars, "none"))
         vars_list           = try(p.vars_list, try(params.vars_list, "none"))
         vars_nested         = try(p.vars_nested, try(params.vars_nested, "none"))
       }
     ]
  ])

  instances          = { for k in local.config: k.type => k.instance_name... }
  disks              = { for k in local.config: k.instance_name => k.extended_disk_name }
  regions            = { for k in local.config: k.instance_name => k.region }
  vars               = { for k in local.config: k.instance_name => k.vars }
  vars_list          = { for k in local.config: k.instance_name => k.vars_list }
  vars_nested        = { for k in local.config: k.instance_name => k.vars_nested }

  project            = local.raw_settings.project
  prefix             = local.raw_settings.prefix
}
