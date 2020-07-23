output "vnet" {
  description = "For a Vnet, returns: <br> -vnet_name <br> - vnet_adress_space <br> - vnet_id <br> - vnet_dns"
  value = {
    "vnet_name"          = azurerm_virtual_network.vnet.name
    "vnet_address_space" = azurerm_virtual_network.vnet.address_space
    "vnet_id"            = azurerm_virtual_network.vnet.id
    "vnet_dns"           = azurerm_virtual_network.vnet.dns_servers
  }
}

output "vnet_obj" {
  value       = azurerm_virtual_network.vnet
  description = "Virtual network object"
}

output "subnet_ids_map" {
  description = "Returns all the subnets objects in the Virtual Network. As a map of keys, ID"
  value = merge(module.special_subnets.subnet_ids_map, module.subnets.subnet_ids_map)
}

output "nsg_obj" {
  value       = module.nsg.nsg_obj
  description = "Returns the complete set of NSG objects created in the virtual network"
}

output "vnet_subnets" {
  description = "Returns a map of subnets from the virtual network: <br> - key = subnet name <br> - value = subnet ID"
  value = merge({
    for subnet in module.subnets.subnet_ids_map :
    subnet.name => subnet.id
    }, {
    for subnet in module.special_subnets.subnet_ids_map :
    subnet.name => subnet.id
    }
  )
}

output "nsg_vnet" {
  description = "Returns a map of nsg from the virtual network: <br>- key = nsg name <br>- value = nsg id"
  value = {
    for nsg in module.nsg.nsg_obj :
    nsg.name => nsg.id
  }
}
