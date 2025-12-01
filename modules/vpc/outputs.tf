output "vpc_id" { value = aws_vpc.this.id }
output "public_subnets" { value = aws_subnet.web_pub[*].id }
output "app_private_subnets" { value = aws_subnet.app_pvt[*].id }
output "db_private_subnets" { value = aws_subnet.db_pvt[*].id }
