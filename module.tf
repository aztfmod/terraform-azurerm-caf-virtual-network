// Creates the networks virtual network, the subnets and associated NSG, with a special section for AzureFirewallSubnet
module "caf_name_vnet" {
  # source  = "git@github.com:aztfmod/terraform-azurerm-caf-naming.git?ref=2001-Refresh"

  source  = "aztfmod/caf-naming/azurerm"
  version = "~> 0.1.0"
  
  name    = var.networking_object.vnet.name
  type    = "vnet"
  convention  = var.convention
}


resource "azurerm_virtual_network" "vnet" {
  name                  = module.caf_name_vnet.vnet
  location              = var.location
  resource_group_name   = var.virtual_network_rg
  address_space         = var.networking_object.vnet.address_space
  tags                  = local.tags

  dns_servers           = lookup(var.networking_object.vnet, "dns", null)

   dynamic "ddos_protection_plan" {
    for_each = lookup(var.networking_object.vnet, "enable_ddos_std", false) == true ? [1] : []
    
    content {
      id     = var.networking_object.vnet.ddos_id
      enable = var.networking_object.vnet.enable_ddos_std
    }
  }
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

module "traffic_analytics" {
  source                    = "./traffic_analytics"

  rg                        = var.virtual_network_rg
  tags                      = var.tags
  location                  = var.location
  log_analytics_workspace   = var.log_analytics_workspace
  diagnostics_map           = var.diagnostics_map
  nw_config                 = lookup(var.networking_object, "netwatcher", {})
  nsg                       = module.nsg.nsg_obj
}

resource "azurerm_subnet_network_security_group_association" "nsg_vnet_association" {
  for_each                  = module.subnets.subnet_ids_map

  subnet_id                 = module.subnets.subnet_ids_map[each.key].id
  network_security_group_id = module.nsg.nsg_obj[each.key].id
}