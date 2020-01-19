
module "rg_test" {
  source  = "aztfmod/caf-resource-group/azurerm"
  version = "0.1.1"
  
    prefix          = local.prefix
    resource_groups = local.resource_groups
    tags            = local.tags
}

module "la_test" {
  source  = "aztfmod/caf-log-analytics/azurerm"
  version = "1.0.0"
  
    convention          = local.convention
    location            = local.location
    name                = local.name_la
    solution_plan_map   = local.solution_plan_map 
    prefix              = local.prefix
    resource_group_name = module.rg_test.names.test
    tags                = local.tags
}

module "diags_test" {
  source  = "aztfmod/caf-diagnostics-logging/azurerm"
  version = "1.0.0"

  name                  = local.name_diags
  convention            = local.convention
  resource_group_name   = module.rg_test.names.test
  prefix                = local.prefix
  location              = local.location
  tags                  = local.tags
}

module "vnet_test" {
  source  = "../.."
    
  convention                        = local.convention
  virtual_network_rg                = module.rg_test.names.test
  prefix                            = local.prefix
  location                          = local.location
  networking_object                 = local.vnet_config
  tags                              = local.tags
  diagnostics_map                   = module.diags_test.diagnostics_map
  log_analytics_workspace           = module.la_test
  diagnostics_settings              = local.vnet_config.diagnostics
}
