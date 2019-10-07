
// Creates the diagnostics settings for the virtual network object
  resource "azurerm_monitor_diagnostic_setting" "vnet_diag" {

   name                             = "${azurerm_virtual_network.vnet.name}-diag"
   target_resource_id               = "${azurerm_virtual_network.vnet.id}"
   eventhub_name                    = "${var.diagnostics_map.eh_name}"
   eventhub_authorization_rule_id   = "${var.diagnostics_map.eh_id}/authorizationrules/RootManageSharedAccessKey"
   log_analytics_workspace_id       = "${var.log_analytics_workspace.id}"
   storage_account_id               = "${var.diagnostics_map.diags_sa}"
   log {
    
            category =  "VMProtectionAlerts"
            retention_policy {
                days   = var.opslogs_retention_period
                enabled = true
            }
            }
   metric {
            category = "AllMetrics"

            retention_policy {
                days    = var.opslogs_retention_period
                enabled = true
                 }
        }
  }  

