variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
}

variable "vm_flavor" {
  description = "VM flavor"
  type        = string
}

variable "admin_username" {
  description = "Admin username for VM"
  type        = string
  default     = "myadminuser"
}

variable "private_key_path" {
  description = "path to private key SSH"
  type        = string
  default     = "/d/terraform/repo/terraform/renta_ssh_key"
}
