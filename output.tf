output "vnet" {
  value = {
  "vnet_name"           = azurerm_virtual_network.vnet.name
  "vnet_adress_space"   = azurerm_virtual_network.vnet.address_space
  "vnet_id"             = azurerm_virtual_network.vnet.id
  "vnet_dns"            = azurerm_virtual_network.vnet.dns_servers
  }
}

output "vnet_obj" {
  value = azurerm_virtual_network.vnet
  description = "Virtual network object"
}

output "subnet_ids_map" {
  value = merge(module.special_subnets.subnet_ids_map, module.subnets.subnet_ids_map)
}

output "nsg_obj" {
  value = module.nsg.nsg_obj
  description = "Returns the complete set of NSG objects created in the virtual network"
}

output "vnet_subnets" {
  value = merge( {
    for subnet in module.subnets.subnet_ids_map:
    subnet.name => subnet.id
    }, {
    for subnet in module.special_subnets.subnet_ids_map:
    subnet.name => subnet.id
    }
    )
}

output "nsg_vnet" {
  value = {
    for nsg in module.nsg.nsg_obj:
    nsg.name => nsg.id
  }
}
