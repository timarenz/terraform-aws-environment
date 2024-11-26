output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_name" {
  value = aws_vpc.main.tags.Name
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "public_subnet_names" {
  value = aws_subnet.public[*].tags.Name
}

output "private_subnet_names" {
  value = aws_subnet.private[*].tags.Name
}

output "public_subnet_availability_zone_names" {
  value = aws_subnet.public[*].availability_zone
}

output "private_subnet_availability_zone_names" {
  value = aws_subnet.private[*].availability_zone
}

output "public_subnet_availability_zone_ids" {
  value = aws_subnet.public[*].availability_zone_id
}

output "private_subnet_availability_zone_ids" {
  value = aws_subnet.private[*].availability_zone_id
}

output "default_route_table_id" {
  value = aws_vpc.main.default_route_table_id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "nat_gateway_public_ip" {
  value = var.nat_gateway ? aws_eip.nat_gw[0].public_ip : null
}

output "cidr_block" {
  value = var.cidr_block
}