variable "recurso_compartido"{
	type		= string
	default		= ""
}
variable "id_cuenta_local" {
  type        	= string
  default		= ""
}
variable "vpc_cidr"{
	type		= string
	default		= ""
}
variable "default_tags" {
  type        = map
  description = "Implements the common_tags scheme"
}
variable "cliente"{
	type		= string
	default		= ""
}
variable "az_name"{
	type		= list(string)
	default		= [""]
}
variable "subnet_cidr_blocks"{
	type		= list(string)
	default		= [""]
}
variable "nombre_aws_region" {
  type        	= string
  default		= ""
}
variable "transit_gw_id"{
	type		= string
	default		= ""
}
variable "transit_gw_id_emea"{
	type		= string
	default		= ""
}
variable "vpgw_1"{
	type		= string
	default		= ""
}
// Variables necesarias usadas desde el VPN
variable "remote_ip_1"{
	type		= string
	default		= ""
}
variable "remote_ip_2_1"{
	type		= string
	default		= ""
}
variable "remote_ip_3_1"{
	type		= string
	default		= ""
}