
// Recursos compartidos desde la cuenta core
# data "aws_ram_resource_share" "ram-name" {
#   provider 					= aws.cuenta_core
#   name           			= var.recurso_compartido
#   resource_owner 			= "SELF"
# }
# resource "aws_ram_principal_association" "ram-principal-association" {
# 	provider				= aws.cuenta_core
# 	principal				= var.id_cuenta_local
# 	resource_share_arn		= data.aws_ram_resource_share.ram-name.arn
# }
// Recursos para la cuenta local
resource "aws_vpc" "VPC-Principal"{
	provider 				= aws.cuenta_local
	cidr_block 				= var.vpc_cidr 
	enable_dns_hostnames 	= true
	tags 					= merge(
		{
			"Name"	= "${var.vpc_cidr}-VPC-${var.cliente}"
		},
		var.default_tags,
	)
}
resource "aws_internet_gateway" "IGW-1"{
	provider 				= aws.cuenta_local
	vpc_id 					= aws_vpc.VPC-Principal.id
	tags 					= merge(
		{
			"Name"	= "IGW-${var.cliente}"
		},
		var.default_tags,
	)
}
resource "aws_subnet" "Subnet-Private1"{
	provider 				= aws.cuenta_local
	vpc_id					= aws_vpc.VPC-Principal.id
	map_public_ip_on_launch = false
	availability_zone		= element(var.az_name,0)
	cidr_block				= element(var.subnet_cidr_blocks,0)
	tags 					= merge(
		{
			"Name"	= "${element(var.subnet_cidr_blocks,0)}-Private1-${element(var.az_name, 0)}"
		},
		var.default_tags,
	)
}
resource "aws_subnet" "Subnet-Private2"{
	provider 				= aws.cuenta_local
	vpc_id					= aws_vpc.VPC-Principal.id
	map_public_ip_on_launch = false
	availability_zone		= element(var.az_name,1)
	cidr_block				= element(var.subnet_cidr_blocks,1)
	tags					= merge(
		{
			"Name"	= "${element(var.subnet_cidr_blocks,1)}-Private2-${element(var.az_name, 1)}"
		},
		var.default_tags,
	)
}
resource "aws_subnet" "Subnet-Public1"{
	provider 				= aws.cuenta_local
	vpc_id					= aws_vpc.VPC-Principal.id
	map_public_ip_on_launch = false
	availability_zone		= element(var.az_name,0)
	cidr_block				= element(var.subnet_cidr_blocks,2)
	tags					= merge(
		{
			"Name"	= "${element(var.subnet_cidr_blocks,2)}-Public1-${element(var.az_name, 0)}"
		},
		var.default_tags,
	)
}
resource "aws_subnet" "Subnet-Public2"{
	provider 				= aws.cuenta_local
	vpc_id					= aws_vpc.VPC-Principal.id
	map_public_ip_on_launch = false
	availability_zone		= element(var.az_name,1)
	cidr_block				= element(var.subnet_cidr_blocks,3)
	tags 					= merge(
		{
			"Name"	= "${element(var.subnet_cidr_blocks,3)}-Public2-${element(var.az_name, 1)}"
		},
		var.default_tags,
	)
}
resource "aws_eip" "EIP-1" {
	provider	= aws.cuenta_local
	tags		= merge(
		{
			"Name"	= "EIP-${var.cliente}-1"
		},
		var.default_tags,
	)
}
resource "aws_eip" "EIP-2" {
	provider	= aws.cuenta_local
	tags		= merge(
		{
			"Name"	= "EIP-${var.cliente}-2"
		},
		var.default_tags,
	)

}
resource "aws_nat_gateway" "NATGW-1" {
	provider				= aws.cuenta_local
	allocation_id			= aws_eip.EIP-1.id
	subnet_id				= aws_subnet.Subnet-Public1.id
	tags					= merge(
		{
			"Name"	= "NAT-${var.cliente}-1"
		},
		var.default_tags,
	)
	depends_on				= [aws_internet_gateway.IGW-1,
		aws_eip.EIP-1,
		aws_subnet.Subnet-Public1
	]
}
resource "aws_nat_gateway" "NATGW-2" {
	provider 				= aws.cuenta_local
	allocation_id 			= aws_eip.EIP-2.id
	subnet_id     			= aws_subnet.Subnet-Public2.id
	tags 					= merge(
		{
			"Name"	= "NAT-${var.cliente}-2"
		},
		var.default_tags,	
	)
	depends_on				= [aws_internet_gateway.IGW-1,
		aws_eip.EIP-2,
		aws_subnet.Subnet-Public2
	]
}
// Atachamos el transit gateway de Emea
# resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-attach" {
# 	provider				= aws.cuenta_local
# 	subnet_ids				= [aws_subnet.Subnet-Private1.id, aws_subnet.Subnet-Private2.id]
# 	transit_gateway_id		= var.transit_gw_id
# 	vpc_id					= aws_vpc.VPC-Principal.id
	
# 	depends_on				= [aws_ram_principal_association.ram-principal-association]
	
# 	tags					= merge(
# 		{
# 			"Name"	= "TGW-Attach-${var.nombre_aws_region}-core"
# 		},
# 		var.default_tags,
# 	)
# }
resource "aws_route_table" "RT-Private1"{
	provider 				= aws.cuenta_local
	vpc_id 					= aws_vpc.VPC-Principal.id
	// IP nodo 1 para Konecta On premises Espana
	# route {
	# 	cidr_block			= "172.15.0.0/16"
	# 	transit_gateway_id	= var.transit_gw_id
	# }
	route {
		cidr_block			= "0.0.0.0/0"
		nat_gateway_id		= aws_nat_gateway.NATGW-1.id 
	}
	depends_on				= [
		# aws_ec2_transit_gateway_vpc_attachment.tgw-attach,
		aws_nat_gateway.NATGW-1
	]
	tags 					= merge(
		{
			"Name"	= "RT-Private1"
		},
		var.default_tags,
	)
}
resource "aws_route_table" "RT-Private2"{
	provider 				= aws.cuenta_local
	vpc_id 					= aws_vpc.VPC-Principal.id
	// IP nodo 1 para Konecta On premises Espana
	# route {
	# 	cidr_block			= "172.15.0.0/16"
	# 	transit_gateway_id	= var.transit_gw_id
	# }
	route {
		cidr_block 			= "0.0.0.0/0"
		nat_gateway_id 		= aws_nat_gateway.NATGW-2.id
	}	
	depends_on				= [
		# aws_ec2_transit_gateway_vpc_attachment.tgw-attach,
		aws_nat_gateway.NATGW-2
	]
	tags 					= merge(
		{
			"Name"	= "RT-Private2"
		},
		var.default_tags,
	)
}
resource "aws_route_table" "RT-Public1"{
	provider				= aws.cuenta_local
	vpc_id					= aws_vpc.VPC-Principal.id
	route {
		cidr_block			= "0.0.0.0/0"
		gateway_id			= aws_internet_gateway.IGW-1.id
	}
	depends_on				= [
		aws_internet_gateway.IGW-1
		# aws_ec2_transit_gateway_vpc_attachment.tgw-attach
	]
	tags					= merge(
		{
			"Name"	= "RT-Public1"
		},
		var.default_tags,
	)
}
resource "aws_route_table" "RT-Public2"{
	provider				= aws.cuenta_local
	vpc_id					= aws_vpc.VPC-Principal.id
	route {
		cidr_block			= "0.0.0.0/0"
		gateway_id			= aws_internet_gateway.IGW-1.id
	}
	depends_on				= [
		aws_internet_gateway.IGW-1
		# aws_ec2_transit_gateway_vpc_attachment.tgw-attach
	]

	tags 					= merge(
		{
			"Name"	= "RT-Public2"
		},
		var.default_tags,
	)
}
resource "aws_main_route_table_association" "RT-Main" {
	provider 				= aws.cuenta_local
	vpc_id         			= aws_vpc.VPC-Principal.id
	route_table_id 			= aws_route_table.RT-Private2.id

	depends_on 				= [
		aws_vpc.VPC-Principal,
		aws_route_table.RT-Private2
	]
}
resource "aws_route_table_association" "RTA-Private1"{
	provider 				= aws.cuenta_local
	route_table_id			= aws_route_table.RT-Private1.id
	subnet_id				= aws_subnet.Subnet-Private1.id
	depends_on 				= [
		aws_route_table.RT-Private1,
		aws_subnet.Subnet-Private1
	]
}
resource "aws_route_table_association" "RTA-Private2"{
	provider 				= aws.cuenta_local
	route_table_id			= aws_route_table.RT-Private2.id
	subnet_id				= aws_subnet.Subnet-Private2.id
	depends_on 				= [
		aws_route_table.RT-Private2,
		aws_subnet.Subnet-Private2
	]
}
resource "aws_route_table_association" "RTA-Public1"{
	provider 				= aws.cuenta_local
	route_table_id			= aws_route_table.RT-Public1.id
	subnet_id				= aws_subnet.Subnet-Public1.id
	depends_on 				= [
		aws_route_table.RT-Public1,
		aws_subnet.Subnet-Public1
	]
}
resource "aws_route_table_association" "RTA-Public2"{
	provider 				= aws.cuenta_local
	route_table_id			= aws_route_table.RT-Public2.id
	subnet_id				= aws_subnet.Subnet-Public2.id
	depends_on 				= [
		aws_route_table.RT-Public2,
		aws_subnet.Subnet-Public2
	]
}
resource "aws_default_network_acl" "ACL-1"{
	provider				= aws.cuenta_local
	default_network_acl_id	= aws_vpc.VPC-Principal.default_network_acl_id
	subnet_ids				= [
		aws_subnet.Subnet-Private1.id, 
		aws_subnet.Subnet-Private2.id, 
		aws_subnet.Subnet-Public1.id, 
		aws_subnet.Subnet-Public2.id
	]

	ingress{
		protocol			= "-1"
		rule_no				= 100
		action				= "allow"
		cidr_block			= "0.0.0.0/0"
		from_port			= 0
		to_port				= 0
	}

	egress{
		protocol			= "-1"
		rule_no				= 100
		action				= "allow"
		cidr_block			= "0.0.0.0/0"
		from_port			= 0
		to_port				= 0
	}

	tags 					= merge(
		{
			"Name"	= "ACL-${var.cliente}-Default"
		},
		var.default_tags,
	)
}
resource "aws_default_security_group" "SG-1"{
	provider				= aws.cuenta_local
	vpc_id					= aws_vpc.VPC-Principal.id
	

	ingress{
		protocol 			= "tcp"
		cidr_blocks			= [aws_vpc.VPC-Principal.cidr_block]
		from_port			= 443
		to_port				= 443
	}

	egress{
		protocol 			= "-1"
		cidr_blocks			= ["0.0.0.0/0"]
		from_port			= 0
		to_port				= 0
	}

	tags 					= merge(
		{
			"Name"	= "SG-${var.cliente}-Default"
		},
		var.default_tags,
	)

}
