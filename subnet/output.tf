
output "subnet_ids_map" {

  depends_on = [azurerm_network_security_group.nsg_obj,azurerm_subnet.v_subnet ]
  value = azurerm_subnet.v_subnet
}
