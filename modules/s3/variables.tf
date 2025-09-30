variable "default_tags" {
  type        = map
  description = "Implements the common_tags scheme"
}
variable "bucket_name"{
	type		= string
	default		= ""
}
variable "bucket_genesys"{
	type		= string
	default		= ""
}

