variable "rg_name" {
  type        = string
  default     = "AVD-RG"
  description = "Name of the Resource group in which to deploy service objects"
}

variable "AVD_vnet_Name" {
  type        = string
  default     = "AVD_vNet-1"
  description = "vNet1 Name"
}

variable "AVD_vNet_Address_Space" {
  type        = list(string)
  default     = ["10.0.1.0/25"]
  description = "vNet1 Address Space"
}

variable "AVD_vnet_Name_2" {
  type        = string
  default     = "AVD_vNet-2"
  description = "vNet2 Name"
}

variable "AVD_vNet_Address_Space_2" {
  type        = list(string)
  default     = ["10.0.1.128/25"]
  description = "vNet2 Address Space"
}