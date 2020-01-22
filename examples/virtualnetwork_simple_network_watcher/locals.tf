locals {
    convention = "cafrandom"
    name = "caftest-vnet-nw"
    name_la = "caftestla"
    name_diags = "caftestdiags"
    location = "southeastasia"
    prefix = ""
    enable_event_hub = false
    resource_groups = {
        test = { 
            name     = "test-caf-vnet-nw"
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
            name                = "_Shared_Services"
            address_space       = ["10.101.4.0/22"]
            dns                 = ["1.2.3.4"]
            enable_ddos_std     = false
            ddos_id             = "/subscriptions/783438ca-d497-4350-aa36-dc55fb0983ab/resourceGroups/testrg/providers/Microsoft.Network/ddosProtectionPlans/test"
        }
        specialsubnets     = {
                            }
        subnets = {
            subnet0                 = {
                name                = "Cycle_Controller"
                cidr                = "10.101.4.0/25"          
            }
            subnet1                 = {
                name                = "Active_Directory"
                cidr                = "10.101.4.128/27"
                # service_endpoints   = []
                nsg_inbound         = [
                    # {"Name", "Priority", "Direction", "Action", "Protocol", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix" }, 
                    ["LDAP", "100", "Inbound", "Allow", "*", "*", "389", "*", "*"],
                    ["RPC-EPM", "102", "Inbound", "Allow", "tcp", "*", "135", "*", "*"],
                    ["SMB-In", "103", "Inbound", "Allow", "tcp", "*", "445", "*", "*"],
                ]
                nsg_outbound        = [
                    ["o-LDAP-t", "100", "Outbound", "Allow", "*", "*", "389", "*", "*"],
                    ["o-SMB-In", "103", "Outbound", "Allow", "tcp", "*", "445", "*", "*"],
                ]       
            }
            subnet2                 = {
                name                = "SQL_Servers"
                cidr                = "10.101.4.160/27"
                # service_endpoints   = []
                nsg_inbound         = [
                    # {"Name", "Priority", "Direction", "Action", "Protocol", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix" }, 
                    ["TDS-In", "100", "Inbound", "Allow", "tcp", "*", "1433", "*", "*"],
                ]       
            }
            subnet3                 = {
                name                = "Network_Monitoring"
                cidr                = "10.101.4.192/27"
                service_endpoints   = ["Microsoft.Sql"]          
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
}