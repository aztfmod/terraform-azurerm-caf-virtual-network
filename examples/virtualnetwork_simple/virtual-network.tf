provider "azurerm" {
   features {}
}

resource "azurerm_resource_group" "rg_test" {
  name     = local.resource_groups.test.name
  location = local.resource_groups.test.location
  tags     = local.tags
}

module "la_test" {
  source  = "aztfmod/caf-log-analytics/azurerm"
  version = "2.0.0"
 
  convention          = local.convention
  location            = local.location
  name                = local.name_la
  solution_plan_map   = local.solution_plan_map 
  prefix              = local.prefix
  resource_group_name = azurerm_resource_group.rg_test.name
  tags                = local.tags
}

module "diags_test" {
  source  = "aztfmod/caf-diagnostics-logging/azurerm"
  version = "1.0.0"
 
  name                  = local.name_diags
  convention            = local.convention
  resource_group_name   = azurerm_resource_group.rg_test.name
  prefix                = local.prefix
  location              = local.location
  tags                  = local.tags
  enable_event_hub      = local.enable_event_hub
}

resource "azurerm_network_ddos_protection_plan" "ddos_protection_plan" {
  name                = local.name_ddos
  location            = local.location
  resource_group_name = azurerm_resource_group.rg_test.name
  tags                = local.tags
}

module "vnet_test" {
  source  = "../.."
    
  convention                        = local.convention
  virtual_network_rg                = azurerm_resource_group.rg_test.name
  prefix                            = local.prefix
  location                          = local.location
  networking_object                 = local.vnet_config
  tags                              = local.tags
  diagnostics_map                   = module.diags_test.diagnostics_map
  log_analytics_workspace           = module.la_test
  diagnostics_settings              = local.vnet_config.diagnostics
  ddos_id = azurerm_network_ddos_protection_plan.ddos_protection_plan.id
}
