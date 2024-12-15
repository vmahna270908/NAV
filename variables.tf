variable "NAV_vnet_Name" {
  type        = string
  default     = "NAV_vNet"
  description = "vNet1 Name"
}

variable "NAV_vNet_Address_Space" {
  type        = list(string)
  default     = ["192.168.0.0/24"]
  description = "vNet1 Address Space"
}