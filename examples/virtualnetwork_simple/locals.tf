locals {
    convention = "cafclassic"
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

    name_ddos = "test_ddos"

    vnet_config = {
        vnet = {
            name                = "TestVnet"
            address_space       = ["10.0.0.0/25", "192.168.0.0/24"]     
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
                nsg_inbound         = [
                    # {"Name", "Priority", "Direction", "Action", "Protocol", "source_port_ranges", "destination_port_ranges", "source_address_prefixes", "destination_address_prefixes", "source_application_security_group_ids", "destination_application_security_group_ids" }, 
                    ["bastion-in-allow", "100", "Inbound", "Allow", "tcp", ["10-15", "20-25"], ["*"], ["*"], ["*"], [""], [""]],
                    ["bastion-control-in-allow-443", "120", "Inbound", "Allow", "tcp", ["*"], ["443-444", "446-447"], ["0.0.0.0/0"], ["*"], [""], [""]],
                    ["bastion-control-in-allow-4443", "121", "Inbound", "Allow", "tcp", ["0-65535"], ["4443"], ["0.0.0.0/0"], ["*"], [""], [""]],
                ]
                nsg_outbound        = [
                    ["bastion-vnet-out-allow-22", "100", "Outbound", "Allow", "tcp", ["0-65535"], ["22"], ["0.0.0.0/0"], ["*"], [""], [""]],
                    ["bastion-vnet-out-allow-3389", "101", "Outbound", "Allow", "tcp", ["0-65535"], ["3389"], ["0.0.0.0/0"], ["*"], [""], [""]],
                    ["bastion-azure-out-allow", "120", "Outbound", "Allow", "tcp", ["0-65535"], ["443"], ["0.0.0.0/0"], ["*"], [""], [""]],
                ]
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