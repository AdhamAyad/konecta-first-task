output "vpc_id" {
  value     = aws_vpc.VPC-Principal.id
}
output "aws_subnets_private1" {
  value     = aws_subnet.Subnet-Private1.id
}
output "aws_subnets_private2" {
  value     = aws_subnet.Subnet-Private2.id
}
output "aws_subnets_public1" {
  value     = aws_subnet.Subnet-Public1.id
}
output "aws_subnets_public2" {
  value     = aws_subnet.Subnet-Public2.id
}