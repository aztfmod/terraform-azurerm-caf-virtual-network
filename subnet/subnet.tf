
# // Creates the vnet's virtual subnetworks

resource "azurerm_subnet" "v_subnet" {
  lifecycle {
        ignore_changes = [network_security_group_id]
    }
  
  for_each                = var.subnets

  name                    = each.value.name
  resource_group_name     = var.resource_group
  virtual_network_name    = var.virtual_network_name
  address_prefix          = each.value.cidr
  service_endpoints       = each.value.service_endpoints
}


