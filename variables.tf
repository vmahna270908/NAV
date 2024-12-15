variable "NAV_vnet_Name" {
  type        = string
  default     = "AZ-NAV-vNet"
  description = "vNet1 Name"
}

variable "NAV_vNet_Address_Space" {
  type        = list(string)
  default     = ["192.168.0.0/24"]
  description = "vNet1 Address Space"
}

variable "NAV_vnet_MGM_Name" {
  type        = string
  default     = "AZ-NAV-vNet-MGM"
  description = "MGM Subnet Name"
}

variable "NAV_vNet_MGM_Address_Space" {
  type        = list(string)
  default     = ["192.168.0.0/29"]
  description = "MGM Address Space"
}

variable "NAV_vnet_LB_Name" {
  type        = string
  default     = "AZ-NAV-vNet-LB"
  description = "LB Subnet Name"
}

variable "NAV_vNet_LB_Address_Space" {
  type        = list(string)
  default     = ["192.168.0.8/29"]
  description = "LB Address Space"
}

variable "NAV_vnet_App_Name" {
  type        = string
  default     = "AZ-NAV-vNet-App"
  description = "App Subnet Name"
}

variable "NAV_vNet_App_Address_Space" {
  type        = list(string)
  default     = ["192.168.0.16/29"]
  description = "App Address Space"
}

variable "NAV_vnet_SQL_Name" {
  type        = string
  default     = "AZ-NAV-vNet-SQL"
  description = "SQL Subnet Name"
}

variable "NAV_vNet_SQL_Address_Space" {
  type        = list(string)
  default     = ["192.168.0.32/28"]
  description = "SQL Address Space"
}

variable "JumpServer1_NIC" {
  type        = string
  default     = "AZ-NAV-JMP1-NIC"
  description = "Jump Server1 NIC"
}

variable "JumpServer1_Name" {
  type        = string
  default     = "AZ-NAV-JMP1"
  description = "Jump Server1 Name"
}

variable "JumpServer2_NIC" {
  type        = string
  default     = "AZ-NAV-JMP2-NIC"
  description = "Jump Server2 NIC"
}

variable "JumpServer2_Name" {
  type        = string
  default     = "AZ-NAV-JMP2"
  description = "Jump Server2 Name"
}

variable "network_interface_name" {
  type        = string
  default     = "AZ-NAV-App-NIC"
  description = "Name of the Network Interface."  
}

variable "virtual_machine_name" {
  type        = string
  default     = "AZ-NAV-App"
  description = "Web Server Name"
}

variable "virtual_machine_size" {
  type        = string
  default     = "Standard_B2s"
  description = "Size or SKU of the Virtual Machine."
}

variable "disk_name" {
  type        = string
  default     = "OS-disk"
  description = "Name of the OS disk of the Virtual Machine."
}

variable "redundancy_type" {
  type        = string
  default     = "Standard_LRS"
  description = "Storage redundancy type of the OS disk."
}

variable "username" {
  type        = string
  default     = "Skywalker"
  description = "The username for the local account that will be created on the new VM."
}

variable "password" {
  type        = string
  default     = "Microsoft@123"
  description = "The password for the local account that will be created on the new VM."
}

variable "load_balancer_name" {
  type        = string
  default     = "AZ-NAV-LB"
  description = "Load Balancer Name"
}

variable "public_ip_name" {
  type        = string
  default     = "AZ-NAV-LB-IP"
  description = "Load Balancer Public IP"
}
