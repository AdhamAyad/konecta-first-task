output "vpc_id" {
  value = aws_vpc.this.id
}

output "private_subnets" {
  value = [aws_subnet.private1.id, aws_subnet.private2.id]
}

output "public_subnets" {
  value = [aws_subnet.public1.id, aws_subnet.public2.id]
}

output "nat_gateways" {
  value = [aws_nat_gateway.nat1.id, aws_nat_gateway.nat2.id]
}

output "internet_gateway_id" {
  value = aws_internet_gateway.this.id
}

output "security_groups" {
  value = [aws_security_group.default.id, aws_security_group.aurora_mysql.id]
}