variable "default_tags" {
  type			= map
  description	= "Implements the common_tags scheme"
}
variable "cliente"{
	type		= string
	default     = ""
}
variable "alerts_email"{
	type		= string
	default		= ""
}
variable "id_cuenta_local" {
  type			= number
  default		= 0
}