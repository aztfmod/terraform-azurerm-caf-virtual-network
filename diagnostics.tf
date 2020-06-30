module "diagnostics_vnet" {
  source = "github.com/aztfmod/terraform-azurerm-caf-diagnostics-logging?ref=vnext"
  # version = "1.0.0"

  name                       = azurerm_virtual_network.vnet.name
  resource_id                = azurerm_virtual_network.vnet.id
  log_analytics_workspace_id = var.log_analytics_workspace.id
  diagnostics_map            = var.diagnostics_map
  diag_object                = var.diagnostics_settings
}