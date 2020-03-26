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
                    # {"Name", "Priority", "Direction", "Action", "Protocol", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix" }, 
                    ["W32Time", "100", "Inbound", "Allow", "udp", "*", "123", "*", "*"],
                    ["RPC-Endpoint-Mapper", "101", "Inbound", "Allow", "tcp", "*", "135", "*", "*"],
                    ["Kerberos-password-change", "102", "Inbound", "Allow", "*", "*", "464", "*", "*"],
                    ["RPC-Dynamic-range", "103", "Inbound", "Allow", "tcp", "*", "49152-65535", "*", "*"],
                    ["LDAP", "104", "Inbound", "Allow", "*", "*", "389", "*", "*"],
                    ["LDAP-SSL", "105", "Inbound", "Allow", "tcp", "*", "636", "*", "*"],
                    ["LDAP-GC", "106", "Inbound", "Allow", "tcp", "*", "3268", "*", "*"],
                    ["LDAP-GC-SSL", "107", "Inbound", "Allow", "tcp", "*", "3269", "*", "*"],
                    ["DNS", "108", "Inbound", "Allow", "*", "*", "53", "*", "*"],
                    ["Kerberos", "109", "Inbound", "Allow", "*", "*", "88", "*", "*"],
                    ["SMB", "110", "Inbound", "Allow", "tcp", "*", "445", "*", "*"],
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