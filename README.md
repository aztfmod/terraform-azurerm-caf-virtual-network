[![Gitter](https://badges.gitter.im/aztfmod/community.svg)](https://gitter.im/aztfmod/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

# Creates a virtual network with associated subnets, network security groups, analytics

Creates a virtual network with:
* Virtual network
* DNS Settings
* Subnet creation
* NSG creation
* DDoS protection standard attachment
* Network Watcher Flow Logs and Traffic Analytics
* Diagnostics logging for the virtual network
* Diagnostics logging for the each sub-network
* Diagnostics logging for the network security groups


Reference the module to a specific version (recommended):
```hcl
module "virtual_network" {
    source  = "aztfmod/caf-virtual-network/azurerm"
    version = "0.x.y"

    virtual_network_rg                = var.rg
    prefix                            = var.prefix
    location                          = var.location
    networking_object                 = var.shared_services_vnet
    tags                              = var.tags
    diagnostics_map                   = var.diagnostics_map
    log_analytics_workspace           = var.log_analytics_workspace
}
```

## Inputs 

| Name | Type | Default | Description |
| -- | -- | -- | -- |
| virtual_network_rg | string | None | (Required) Name of the resource group where to create the resource. Changing this forces a new resource to be created. |
| location | string | None | (Required) Specifies the Azure location to deploy the resource. Changing this forces a new resource to be created.  |
| tags | map | None | (Required) Map of tags for the deployment.  |
| log_analytics_workspace | string | None | (Required) Log Analytics Workspace. |
| diagnostics_map | map | None | (Required) Map with the diagnostics repository information.  |
| diagnostics_settings | object | None | (Required) Map with the diagnostics settings. See the required structure in the following example or in the diagnostics module documentation. |
| convention | string | None | (Required) Naming convention to be used (check at the naming convention module for possible values).  |
| prefix | string | None | (Optional) Prefix to be used. |
| networking_object | object | None | (Required) Virtual Network configuration object as described in the Parameters section.  |
| netwatcher | map(strings) | None | (Optional) Specifies the pre-existing network watcher configuration to use for this virtual network. The map should be defined as follow:  <br> - name = (name of the pre-existing network watcher configuration) <br> - rg (resource group of the pre-existing network watcher configuration) |
| ddos_id  | string | None | (Optional), if this field is set, we will enable ddos for the virtual network using the subscription ID passed with this argument. |


## Parameters

### diagnostics_settings
(Required) Map with the diagnostics settings for virtual network deployment.
See the required structure in the following example or in the diagnostics module documentation.

```hcl
variable "diagnostics_settings" {
 description = "(Required) Map with the diagnostics settings for public virtual network deployment"
}
```

Example

```hcl
diagnostics_settings = {
    log = [
                # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
                ["VMProtectionAlerts", true, true, 60],
        ]
    metric = [
                #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
                  ["AllMetrics", true, true, 60],
    ]
}
```

### networking_object

(Required) Configuration object describing the networking configuration.
The object has 3 mandatory sections as follow:

#### vnet

| input | type | optional | comment |
| -- | -- | -- | -- |
| name | string | mandatory | name of the virtul network to be created |
| address_space  | list | optional | address speace for the subnet |
| dns  | list | optional | if not provided,uses the default Azure DNS |


#### specialsubnets

| input | type | optional | comment |
| -- | -- | -- | -- |
| subnet_key_name | object | mandatory | specialsubnets is use to create specific subnets where you dont want default NSG to be created, for instance AzureFirewallSubnet must be created via this object. (see below for example) |

#### subnets

For each subnet, create an object that contain the following fields (see example below)

| input | type | optional | comment |
| -- | -- | -- | -- |
| name | object | mandatory | name of the virtual subnet |
| cidr | object | mandatory | CIDR block for the virtual subnet |
| service_endpoints | object | mandatory | service endpoints for the virtual subnet |
| nsg_inbound | object | optional | network security groups settings - a NSG is always created for each subnet - this section will tune the NSG entries for inbound flows. |
| nsg_outbound | object | optional | network security groups settings - a NSG is always created for each subnet - this section will tune the NSG entries for outbound flows. |
| delegation | object | optional | defines a subnet delegation feature. takes an object as described in the following example. |

The following sections are optional:

#### netwatcher

If this object is defined, it will enable network watcher, flow logs and traffic analytics for all the subnets in the Virtual Network. The configuration object is as follow:

| input | type | optional | comment |
| -- | -- | -- | -- |
| create | bool | mandatory | determines if network watcher should be created or should be used from a previous deployment. <br> /!\ If set to false, the netwatcher optional variable must be set. |
| name | string | mandatory | name of the network watcher to be created |
| flow_logs_settings | object | mandatory | specifies the configuration for flow logs according to the following object structure: <br> enabled = (bool) <br>  retention = (bool)  <br>  period = (integer)
| traffic_analytics_settings | object | mandatory | specifies if traffic analytics should be enabled. If enabled, we use the settings defined in the virtual network settings (log_analytics_workspace). |



The following networking_object shows an example of composition:

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
                delegation          = {
                    name = "acctestdelegation1"
                    service_delegation = {
                    name    = "Microsoft.ContainerInstance/containerGroups"
                    actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
                    }
                }
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
        netwatcher = {
            create = true
            #create the network watcher for a subscription and for the location of the vnet
            name   = "nwtest"
            #name of the network watcher to be created

            flow_logs_settings = {
                enabled = true
                retention = true
                period = 7
            }

            traffic_analytics_settings = {
                enabled = true
            }
        }
}
```

## Output

| Name | Type | Description |
| -- | -- | -- |
| vnet | map(strings) | For a Vnet, returns: <br> -vnet_name <br> - vnet_adress_space <br> - vnet_id <br> - vnet_dns |
| vnet_obj | object | Returns the virtual network object with its full properties details. |
| subnet_ids_map | object | Returns all the subnets objects in the Virtual Network.  | 
| nsg_obj | object | For all the subnets within the virtual network, returns the list subnets with their full details for user defined NSG. |
| vnet_subnets | map | Returns a map of subnets from the virtual network: <br> - key = subnet name <br> - value = subnet ID |
| nsg_vnet | string | Returns a map of nsg from the virtual network: <br>- key = nsg name <br>- value = nsg id |
