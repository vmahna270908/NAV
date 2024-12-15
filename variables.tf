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