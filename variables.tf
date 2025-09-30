variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "private1_cidr" {
  description = "CIDR block for private subnet 1"
  type        = string
}

variable "private2_cidr" {
  description = "CIDR block for private subnet 2"
  type        = string
}

variable "public1_cidr" {
  description = "CIDR block for public subnet 1"
  type        = string
}

variable "public2_cidr" {
  description = "CIDR block for public subnet 2"
  type        = string
}

variable "az1" {
  description = "Availability Zone 1"
  type        = string
}

variable "az2" {
  description = "Availability Zone 2"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}
