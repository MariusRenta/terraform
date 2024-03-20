# Output VM private IP addresses
output "vm_private_ip_addresses" {
  value = azurerm_network_interface.renta_nic[*].private_ip_address
}

# Output ping results
output "ping_results" {
  value = null_resource.ping_between_vms[*]
}
