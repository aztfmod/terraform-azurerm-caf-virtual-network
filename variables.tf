
variable "virtual_network_rg" {
  description = "(Required) Name of the resource group where to create the vnet"
  type        = string
}

variable "location" {
  description = "(Required) Define the region where the resource groups will be created"
  type        = string
}

variable "prefix" {
  description = "(Optional) You can use a prefix to add to the list of resource groups you want to create"
  type        = string
}

variable "tags" {
  description = "(Required) map of tags for the deployment"
}

variable "diagnostics_map" {
  description = "(Required) contains the SA and EH details for operations diagnostics"
}

variable "log_analytics_workspace" {
  description = "(Required) contains the log analytics workspace details for operations diagnostics"
}

variable "opslogs_retention_period" {
  description = "(Optional) Number of days to keep operations logs inside storage account"
  default = 60
}

variable "networking_object" {
  description = "(Required) configuration object describing the networking configuration, as described below"
}

# Sample of network configuration object below
#   networking_object = {
#     region1 = {
#         vnet = {
#             name                = "sg1-vnet-dmz"
#             address_space       = ["10.101.4.0/22"]     # 10.100.4.0 - 10.100.7.255
#             dns                 = ["192.168.0.16", "192.168.0.64"]
#             ddos_standard       = true                  # for future use
#         }
#         specialsubnets     = {
#                 AzureFirewallSubnet = {
#                 name                = "AzureFirewallSubnet"
#                 cidr                = "10.101.4.0/25"
#                 service_endpoints   = []
#                 }
#             }
#         subnets = {
#             Subnet_1        = {
#                 name                = "Active_Directory"
#                 cidr                = "10.101.4.128/27"
#                 service_endpoints   = []
#                 nsg_inbound         = [
#                     # {"Name", "Priority", "Direction", "Action", "Protocol", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix" }, 
#                     ["LDAP-t", "100", "Inbound", "Allow", "*", "*", "389", "*", "*"],
#                     ["RPC-EPM", "102", "Inbound", "Allow", "tcp", "*", "135", "*", "*"],
#                     ["SMB-In", "103", "Inbound", "Allow", "tcp", "*", "445", "*", "*"],
#                 ]
#                 nsg_outbound        = []
#             }
#             Subnet_2             = {
#                 name                = "SQL_Servers"
#                 cidr                = "10.101.4.160/27"
#                 service_endpoints   = []
#                 nsg_inbound         = [
#                     ["SQL", "100", "Inbound", "Allow", "tcp", "*", "1433", "*", "*"],
#                 ]
#                 nsg_outbound        = []
#             }
#             Subnet_3       = {
#                 name                = "Network_Monitoring"
#                 cidr                = "10.101.4.192/27"
#                 service_endpoints   = ["Microsoft.EventHub"]
#                 nsg_inbound         = [
#                     # ["Test", "101", "Inbound", "Allow", "tcp", "*", "1643", "*", "*"],
#                 ]
#                 nsg_outbound        = []
#             }
#             # Subnet_4       = {
#             #     name                = "Intranet"
#             #     cidr                = "10.101.5.0/24"
#             #     service_endpoints   = ["Microsoft.EventHub"]
#             #     nsg_inbound         = []
#             #     nsg_outbound        = []
#             # }
#             # Subnet_5       = {
#             #     name                = "Biztalk"
#             #     cidr                = "10.101.6.0/24"
#             #     service_endpoints   = ["Microsoft.EventHub"]
#             #     nsg_inbound         = []
#             #     nsg_outbound        = []
#             # }
#             # Subnet_6       = {
#             #     name                = "IDS"
#             #     cidr                = "10.101.7.0/24"
#             #     service_endpoints   = ["Microsoft.EventHub"]
#             #     nsg_inbound         = []
#             #     nsg_outbound        = []
#             # }

#         }
# }
# }