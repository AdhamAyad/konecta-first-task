variable "default_tags" {
  type        = map
  description = "Implements the common_tags scheme"
}
variable "bucket_arn"{
	type		= string
	default		= ""
}
variable "bucket_name"{
	type		= string
	default		= ""
}
variable "cuenta_genesys"{
	type		= string
	default		= ""
}
variable "external_id"{
	type		= string
	default		= ""
}
variable "cuenta_grabaciones"{
	type		= string
	default		= ""
}
variable "arn_contenedor"{
	type		= string
	default		= ""
}
variable "arn_lambda"{
	type		= string
	default		= ""
}
variable "bucket_genesys" {
  type    = string
  default = ""
}
