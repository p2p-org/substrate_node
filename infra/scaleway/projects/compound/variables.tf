variable "snapshot_name" {
  default = null
}

variable "access_key" {
  default     = null
  type        = string
  sensitive   = true
}

variable "secret_key" {
  default     = null
  type        = string
  sensitive   = true
}

variable "inventory_path" {
  default = "../../../../inventory"
}
