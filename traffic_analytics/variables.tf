variable "nw_config" {
  description = "(Optional) Configuration settings for network watcher."
  default = {
            create = false
            #create the network watcher for a subscription and for the location of the vnet
            name   = "nwtest"
            #name of the network watcher to be created

            flow_logs_settings = {
                enabled = false
                retention = true
                period = 7
            }

            traffic_analytics_settings = {
                enabled = false
            }
        }
}

variable "nsg" {
  description = "(Required) NSG list of objects"
}

variable "rg" {
  
}

variable "diagnostics_map" {
  
}

variable "log_analytics_workspace" {
  
}


variable "location" {
  
}

variable "netwatcher" {
  description = "(Optional) is a map with two attributes: name, rg who describes the name and rg where the netwatcher was already deployed" 
}

variable "tags" {
  
}
