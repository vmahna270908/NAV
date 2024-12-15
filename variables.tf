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
  default     = ["192.168.0.24/29"]
  description = "SQL Address Space"
}