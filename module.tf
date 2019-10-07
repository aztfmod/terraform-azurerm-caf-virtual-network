// Creates the networks virtual network, the subnets and associated NSG, with a special section for AzureFirewallSubnet

resource "azurerm_virtual_network" "vnet" {
  name                  = "${var.prefix}${var.networking_object.vnet.name}"
  location              = var.location
  resource_group_name   = var.virtual_network_rg
  address_space         = var.networking_object.vnet.address_space
  dns_servers           = var.networking_object.vnet.dns
  tags                  = local.tags

  # ddos_protection_plan {
  #   id     = "${azurerm_ddos_protection_plan.test.id}"
  #   enable = true
  # }
  
}

module "special_subnets" {
  source                = "./subnet"

  resource_group        = var.virtual_network_rg
  virtual_network_name  = azurerm_virtual_network.vnet.name
  subnets               = var.networking_object.specialsubnets
  tags                  = local.tags
  location              = var.location
}

module "subnets" {
  source                = "./subnet"

  resource_group        = var.virtual_network_rg
  virtual_network_name  = azurerm_virtual_network.vnet.name
  subnets               = var.networking_object.subnets
  tags                  = local.tags
  location              = var.location
}

module "nsg" {
  source                    = "./nsg"

  resource_group            = var.virtual_network_rg
  virtual_network_name      = azurerm_virtual_network.vnet.name
  subnets                   = var.networking_object.subnets
  tags                      = local.tags
  location                  = var.location
  log_analytics_workspace   = var.log_analytics_workspace
  diagnostics_map           = var.diagnostics_map
}



resource "azurerm_subnet_network_security_group_association" "nsg_vnet_association" {
  for_each                  = module.subnets.subnet_ids_map

  subnet_id                 = module.subnets.subnet_ids_map[each.key].id
  network_security_group_id = module.nsg.nsg_obj[each.key].id
}