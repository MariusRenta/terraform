# Output ping results
output "ping_results" {
  value = azurerm_network_interface.renta_nic[*].private_ip_address
}
