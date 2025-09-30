resource "aws_vpc" "reporting" {
  cidr_block = "10.133.29.64/26"

  tags = {
    Country  = "Espana"
    Project  = "Reporting Agencia"
    Platform = "Terraform"
    Name     = "10.133.29.64/26-VPC-Reporting_agencia"
  }
}

resource "aws_subnet" "private1_eu_west_1a" {
  vpc_id                  = "vpc-016c4e6a44c5cfdbc"
  cidr_block              = "10.133.29.64/28"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = false

  tags = {
    Country  = "Espana"
    Project  = "Reporting Agencia"
    Platform = "Terraform"
    Name     = "10.133.29.64/28-Private1-eu-west-1a"
  }
}

resource "aws_subnet" "public1_eu_west_1a" {
  vpc_id                  = "vpc-016c4e6a44c5cfdbc"
  cidr_block              = "10.133.29.96/28"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = false

  tags = {
    Country  = "Espana"
    Project  = "Reporting Agencia"
    Platform = "Terraform"
    Name     = "10.133.29.96/28-Public1-eu-west-1a"
  }
}

resource "aws_subnet" "public2_eu_west_1b" {
  vpc_id                  = "vpc-016c4e6a44c5cfdbc"
  cidr_block              = "10.133.29.112/28"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = false

  tags = {
    Country  = "Espana"
    Project  = "Reporting Agencia"
    Platform = "Terraform"
    Name     = "10.133.29.112/28-Public2-eu-west-1b"
  }
}

resource "aws_subnet" "private2_eu_west_1b" {
  vpc_id                  = "vpc-016c4e6a44c5cfdbc"
  cidr_block              = "10.133.29.80/28"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = false

  tags = {
    Country  = "Espana"
    Project  = "Reporting Agencia"
    Platform = "Terraform"
    Name     = "10.133.29.80/28-Private2-eu-west-1b"
  }
}