variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "country" {
  description = "Country tag for resources"
  type        = string
}

variable "project" {
  description = "Project tag for resources"
  type        = string
}

variable "platform" {
  description = "Platform tag for resources"
  type        = string
}

variable "private_subnets" {
  description = "Private subnets with CIDR and AZ"
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "public_subnets" {
  description = "Public subnets with CIDR and AZ"
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "private_route_tables" {
  description = "Private route tables with names"
  type = map(object({
    name = string
  }))
}

variable "public_route_tables" {
  description = "Public route tables with names"
  type = map(object({
    name = string
  }))
}

variable "igw_name" {
  description = "Name for Internet Gateway"
  type        = string
}

variable "eips" {
  description = "Elastic IPs with names"
  type = map(object({
    name = string
  }))
}

variable "nat_gateways" {
  description = "NAT gateways with linked EIP and subnet"
  type = map(object({
    name   = string
    eip    = string
    subnet = string
  }))
}

variable "security_groups" {
  description = "Security groups with ingress/egress rules"
  type = map(object({
    name        = string
    description = string
    ingress     = list(object({ from_port = number, to_port = number, protocol = string, cidr_blocks = list(string) }))
    egress      = list(object({ from_port = number, to_port = number, protocol = string, cidr_blocks = list(string) }))
  }))
}

variable "tgw_id" {
  description = "Transit Gateway ID"
  type        = string
}

variable "tgw_subnets" {
  description = "Subnets for TGW attachment"
  type        = list(string)
}

variable "tgw_name" {
  description = "TGW attachment name"
  type        = string
}

variable "default_acl_id" {
  description = "Default Network ACL ID"
  type        = string
}

variable "default_acl_subnets" {
  description = "Subnets associated with default ACL"
  type        = list(string)
}

variable "default_acl_ingress" {
  description = "Ingress rules for default ACL"
  type = list(object({ rule_no=number, protocol=string, action=string, cidr_block=string, from_port=number, to_port=number }))
}

variable "default_acl_egress" {
  description = "Egress rules for default ACL"
  type = list(object({ rule_no=number, protocol=string, action=string, cidr_block=string, from_port=number, to_port=number }))
}

variable "default_acl_name" {
  description = "Name for default network ACL"
  type        = string
}