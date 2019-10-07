//Creates the NSG diag objects
resource "azurerm_monitor_diagnostic_setting" "nsg_diag" {
depends_on          = [azurerm_network_security_group.nsg_obj]

for_each            = azurerm_network_security_group.nsg_obj

name                = each.value.name
target_resource_id  = each.value.id
eventhub_name                    = "${var.diagnostics_map.eh_name}"
eventhub_authorization_rule_id   = "${var.diagnostics_map.eh_id}/authorizationrules/RootManageSharedAccessKey"
log_analytics_workspace_id       = "${var.log_analytics_workspace.id}"
storage_account_id               = "${var.diagnostics_map.diags_sa}"
log {
    
    category =  "NetworkSecurityGroupRuleCounter"
    retention_policy {
      days   = var.opslogs_retention_period
      enabled = true

    }
    }
log {
    
    category =  "NetworkSecurityGroupEvent"
    retention_policy {
      days   = var.opslogs_retention_period
      enabled = true

    }
    }
}