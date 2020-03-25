resource "azurerm_network_security_group" "nsg_obj" {

  for_each              = var.subnets

  name                    = each.value.name
  resource_group_name     = var.resource_group
  location                = var.location
  tags                    = var.tags

  dynamic "security_rule" {

    for_each = concat(lookup(each.value, "nsg_inbound", []), lookup(each.value, "nsg_outbound", []))
    content {
      name                                        = security_rule.value[0]
      priority                                    = security_rule.value[1]
      direction                                   = security_rule.value[2]
      access                                      = security_rule.value[3]
      protocol                                    = security_rule.value[4]
      source_port_ranges                          = security_rule.value[5] == ["*"] ? ["0-65535"] : security_rule.value[5]
      destination_port_ranges                     = security_rule.value[6] == ["*"] ? ["0-65535"] : security_rule.value[6]
      source_address_prefixes                     = security_rule.value[7] == ["*"] ? ["0.0.0.0/0", "::/0"] : security_rule.value[7]
      destination_address_prefixes                = security_rule.value[8] == ["*"] ? ["0.0.0.0/0", "::/0"] : security_rule.value[8]
      source_application_security_group_ids       = security_rule.value[9] != [""] ? security_rule.value[9] : null
      destination_application_security_group_ids  = security_rule.value[10] != [""] ? security_rule.value[10] : null
    }
  }
}
