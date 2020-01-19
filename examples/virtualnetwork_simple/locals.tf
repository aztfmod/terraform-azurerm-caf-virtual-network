locals {
    convention = "cafrandom"
    name = "caftest-vnet"
    name_la = "caftestlavalid"
    name_diags = "caftestdiags"
    location = "southeastasia"
    prefix = ""
    enable_event_hub = false
    resource_groups = {
        test = { 
            name     = "test-caf-aznetsimple"
            location = "southeastasia" 
        },
    }
    tags = {
        environment     = "DEV"
        owner           = "CAF"
    }
    solution_plan_map = {
        NetworkMonitoring = {
            "publisher" = "Microsoft"
            "product"   = "OMSGallery/NetworkMonitoring"
        },
    }

    vnet_config = {
        vnet = {
            name                = "TestVnet"
            address_space       = ["10.0.0.0/25"]     
            dns                 = ["192.168.0.16", "192.168.0.64"]
        }
        specialsubnets     = {
            AzureFirewallSubnet     = {
                name                = "AzureFirewallSubnet"
                cidr                = "10.0.0.0/26"
                service_endpoints   = []
            }
            }
        subnets = {
            subnet1                 = {
                name                = "Network_Monitoring"
                cidr                = "10.0.0.64/26"
                service_endpoints   = []
                nsg_inbound         = []
                nsg_outbound        = []
            }
        }
        diagnostics = {
            log = [
                    # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period] 
                    ["VMProtectionAlerts", true, true, 60],
            ]
            metric = [
                    #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]                 
                    ["AllMetrics", true, true, 60],
            ]   
        }
    }
}