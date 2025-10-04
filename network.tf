resource "aws_vpc" "reporting_agencia" {
  cidr_block = "10.133.29.64/26"

  tags = {
    Name     = "10.133.29.64/26-VPC-Reporting_agencia"
    Country  = "Espana"
    Project  = "Reporting Agencia"
    Platform = "Terraform"
  }
}

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.reporting_agencia.id
  cidr_block        = "10.133.29.64/28"
  availability_zone = "eu-west-1a"

  tags = {
    Name     = "10.133.29.64/28-Private1-eu-west-1a"
    Country  = "Espana"
    Project  = "Reporting Agencia"
    Platform = "Terraform"
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.reporting_agencia.id
  cidr_block        = "10.133.29.80/28"
  availability_zone = "eu-west-1b"

  tags = {
    Name     = "10.133.29.80/28-Private2-eu-west-1b"
    Country  = "Espana"
    Project  = "Reporting Agencia"
    Platform = "Terraform"
  }
}

resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.reporting_agencia.id
  cidr_block        = "10.133.29.96/28"
  availability_zone = "eu-west-1a"

  tags = {
    Name     = "10.133.29.96/28-Public1-eu-west-1a"
    Country  = "Espana"
    Project  = "Reporting Agencia"
    Platform = "Terraform"
  }
}

resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.reporting_agencia.id
  cidr_block        = "10.133.29.112/28"
  availability_zone = "eu-west-1b"

  tags = {
    Name     = "10.133.29.112/28-Public2-eu-west-1b"
    Country  = "Espana"
    Project  = "Reporting Agencia"
    Platform = "Terraform"
  }
}

resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.reporting_agencia.id

  tags = {
    Name     = "RT-Private1"
    Country  = "Espana"
    Project  = "Reporting Agencia"
    Platform = "Terraform"
  }
}

resource "aws_route_table" "private2" {
  vpc_id = aws_vpc.reporting_agencia.id

  tags = {
    Name     = "RT-Private2"
    Country  = "Espana"
    Project  = "Reporting Agencia"
    Platform = "Terraform"
  }
}

resource "aws_route_table" "public1" {
  vpc_id = aws_vpc.reporting_agencia.id

  tags = {
    Name     = "RT-Public1"
    Country  = "Espana"
    Project  = "Reporting Agencia"
    Platform = "Terraform"
  }
}

resource "aws_route_table" "public2" {
  vpc_id = aws_vpc.reporting_agencia.id

  tags = {
    Name     = "RT-Public2"
    Country  = "Espana"
    Project  = "Reporting Agencia"
    Platform = "Terraform"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.reporting_agencia.id

  tags = {
    Name     = "IGW-Reporting_agencia"
    Country  = "Espana"
    Project  = "Reporting Agencia"
    Platform = "Terraform"
  }
}

resource "aws_eip" "eip1" {
  tags = {
    Name     = "EIP-Reporting_agencia-1"
    Country  = "Espana"
    Project  = "Reporting Agencia"
    Platform = "Terraform"
  }
}

resource "aws_eip" "eip2" {
  tags = {
    Name     = "EIP-Reporting_agencia-2"
    Country  = "Espana"
    Project  = "Reporting Agencia"
    Platform = "Terraform"
  }
}

resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name     = "NAT-Reporting_agencia-1"
    Country  = "Espana"
    Project  = "Reporting Agencia"
    Platform = "Terraform"
  }
}

resource "aws_nat_gateway" "nat2" {
  allocation_id = aws_eip.eip2.id
  subnet_id     = aws_subnet.public2.id

  tags = {
    Name     = "NAT-Reporting_agencia-2"
    Country  = "Espana"
    Project  = "Reporting Agencia"
    Platform = "Terraform"
  }
}

resource "aws_security_group" "default" {
  vpc_id      = aws_vpc.reporting_agencia.id
  description = "default VPC security group"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.133.29.64/26"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "SG-Reporting_agencia-Default"
    Country  = "Espana"
    Project  = "Reporting Agencia"
    Platform = "Terraform"
  }
}

resource "aws_security_group" "aurora_mysql" {
  vpc_id = aws_vpc.reporting_agencia.id

  tags = {
    Name     = "SG-Reporting_agencia-RDS-aurora-mysql"
    Country  = "Espana"
    Project  = "Reporting Agencia"
    Platform = "Terraform"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach" {
  vpc_id             = aws_vpc.reporting_agencia.id
  transit_gateway_id = "tgw-0f6739e2525074a0a"

  subnet_ids = [
    "subnet-08cd870b73d40786b",
    "subnet-0fec94f2450c87a84"
  ]

  tags = {
    Country  = "Espana"
    Name     = "TGW-Attach-Irlanda-core"
    Platform = "Terraform"
    Project  = "Reporting Agencia"
  }
}


resource "aws_default_network_acl" "default" {
  default_network_acl_id = "acl-07ef47749df8c9f72"

  subnet_ids = [
    "subnet-05f6f6a06adb5cac8",
    "subnet-088a6fd452f66cc02",
    "subnet-08cd870b73d40786b",
    "subnet-0fec94f2450c87a84",
  ]

  ingress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name     = "ACL-Reporting_agencia-Default"
    Project  = "Reporting Agencia"
    Country  = "Espana"
    Platform = "Terraform"
  }
}
