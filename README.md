[![Build status](https://dev.azure.com/azure-terraform/Blueprints/_apis/build/status/modules/virtual_network)](https://dev.azure.com/azure-terraform/Blueprints/_build/latest?definitionId=8)
# Creates a virtual network with associated subnets and network security groups

Creates a virtual network with:
* Virtual network
* DNS Settings
* Subnet creation
* NSG creation
* Diagnostics logging for the virtual network
* Diagnostics logging for the each sub-network
* Diagnostics logging for the network security groups


Reference the module to a specific version (recommended):
```hcl
module "virtual_network" {
    source  = "aztfmod/caf-virtual-network/azurerm"
    version = "0.1.0"

    virtual_network_rg                = var.rg
    prefix                            = var.prefix
    location                          = var.location
    networking_object                 = var.shared_services_vnet
    tags                              = var.tags
    diagnostics_map                   = var.diagnostics_map
    log_analytics_workspace           = var.log_analytics_workspace
}
```

Or get the latest version
```hcl
module "virtual_network" {
    source                  = "git://github.com/aztfmod/virtual_network.git?ref=latest"
  
    virtual_network_rg                = var.rg
    prefix                            = var.prefix
    location                          = var.location
    networking_object                 = var.shared_services_vnet
    tags                              = var.tags
    diagnostics_map                   = var.diagnostics_map
    log_analytics_workspace           = var.log_analytics_workspace
}
```

# Parameters

## virtual_network_rg
Required) Name of the resource group where to create the vnet
```hcl
variable "virtual_network_rg" {
  description = "(Required) Name of the resource group where to create the vnet"
  type        = string
}

```
Example
```hcl
virtual_network_rg = "my-vnet"
```

## location
(Required) Define the region where the resource groups will be created
```hcl

variable "location" {
  description = "(Required) Define the region where the resource groups will be created"
  type        = string
}
```
Example
```
    location    = "southeastasia"
```

## prefix
(Optional) You can use a prefix to add to the list of resource groups you want to create
```hcl
variable "prefix" {
    description = "(Optional) You can use a prefix to add to the list of resource groups you want to create"
}
```
Example
```hcl
locals {
    prefix = "${random_string.prefix.result}-"
}

resource "random_string" "prefix" {
    length  = 4
    upper   = false
    special = false
}
```

## tags
(Required) Map of tags for the deployment
```hcl
variable "tags" {
  description = "(Required) map of tags for the deployment"
}
```
Example
```hcl
tags = {
    environment     = "DEV"
    owner           = "Arnaud"
    deploymentType  = "Terraform"
  }
```

## diagnostics_map
(Required) Contains the Storage Account and Event Hubs details for operations diagnostics
```hcl
variable "diagnostics_map" {
  description = "(Required) contains the SA and EH details for operations diagnostics"
}
```
Example
```hcl
 diagnostics_map = {
      diags_sa      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/operations-rg/providers/Microsoft.Storage/storageAccounts/opslogs"
      eh_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/operations-rg/providers/Microsoft.EventHub/namespaces/opslogs"
      eh_name       = "opslogs"
  }
```
## log_analytics_workspace
(Required) contains the log analytics workspace details for operations diagnostics."

```hcl
variable "log_analytics_workspace" {
  description = "(Required) contains the log analytics workspace details for operations diagnostics"
}
```
Example
```hcl
  log_analytics_workspace = {
        id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/operations-rg/providers/microsoft.operationalinsights/workspaces/lalogs"
        name = "lalogs"
  }
```

## opslogs_retention_period
(Optional) Number of days to keep operations logs inside storage account"

```hcl
variable "opslogs_retention_period" {
  description = "(Optional) Number of days to keep operations logs inside storage account"
  default = 60
}
```
Example
```hcl
opslogs_retention_period = 90

```

## networking_object
(Required) Configuration object describing the networking configuration, as described below"

```hcl
variable "networking_object" {
  description = "(Required) configuration object describing the networking configuration, as described below"
}
```
Example
```hcl
Sample of network configuration object below
  networking_object = {
        vnet = {
            name                = "sg1-vnet-dmz"
            address_space       = ["10.101.4.0/22"]     # 10.100.4.0 - 10.100.7.255
            dns                 = ["192.168.0.16", "192.168.0.64"]
        }
        specialsubnets     = {
                AzureFirewallSubnet = {
                name                = "AzureFirewallSubnet"
                cidr                = "10.101.4.0/25"
                service_endpoints   = []
                }
            }
        subnets = {
            Subnet_1        = {
                name                = "Active_Directory"
                cidr                = "10.101.4.128/27"
                service_endpoints   = []
                nsg_inbound         = [
                    # {"Name", "Priority", "Direction", "Action", "Protocol", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix" }, 
                    ["LDAP-t", "100", "Inbound", "Allow", "*", "*", "389", "*", "*"],
                    ["RPC-EPM", "102", "Inbound", "Allow", "tcp", "*", "135", "*", "*"],
                    ["SMB-In", "103", "Inbound", "Allow", "tcp", "*", "445", "*", "*"],
                ]
                nsg_outbound        = []
            }
            Subnet_2             = {
                name                = "SQL_Servers"
                cidr                = "10.101.4.160/27"
                service_endpoints   = []
                nsg_inbound         = [
                    ["SQL", "100", "Inbound", "Allow", "tcp", "*", "1433", "*", "*"],
                ]
                nsg_outbound        = []
            }
            Subnet_3       = {
                name                = "Network_Monitoring"
                cidr                = "10.101.4.192/27"
                service_endpoints   = ["Microsoft.EventHub"]
                nsg_inbound         = [
                    # ["Test", "101", "Inbound", "Allow", "tcp", "*", "1643", "*", "*"],
                ]
                nsg_outbound        = []
            }
        }
}

```


# Output
## vnet
Returns an object: 
  "vnet_name"           = azurerm_virtual_network.vnet.name
  "vnet_adress_space"   = azurerm_virtual_network.vnet.address_space
  "vnet_id"             = azurerm_virtual_network.vnet.id
  "vnet_dns"            = azurerm_virtual_network.vnet.dns_servers


## vnet_obj
Returns the virtual network object with its full properties details.

## subnet_ids_map_region1
For all the subnets within the virtual network, returns the list subnets with summary properties. 

## nsg_obj
For all the subnets within the virtual network, returns the list subnets with their full details for user defined NSG. 

## vnet_subnets
Returns a map of subnets from the virtual network:
- key = subnet name
- value = subnet id

## nsg_vnet
Returns a map of nsg from the virtual network:
- key = nsg name
- value = nsg id