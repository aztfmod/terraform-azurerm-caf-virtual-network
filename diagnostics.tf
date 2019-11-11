module "diagnostics_vnet" {
  source  = "aztfmod/caf-diagnostics/azurerm"
  version = "0.1.1"

    name                            = azurerm_virtual_network.vnet.name
    resource_id                     = azurerm_virtual_network.vnet.id
    log_analytics_workspace_id      = var.log_analytics_workspace.id
    diagnostics_map                 = var.diagnostics_map
    diag_object                     = var.diagnostics_settings
}