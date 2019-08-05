data "aws_region" "current" {}

locals {
  common_tags = {
    environment = var.environment_name
    owner       = var.owner_name
    ttl         = var.ttl
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, var.tags == null ? {} : var.tags, { Name = "${var.environment_name}-vpc" })
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = lookup(var.public_subnets[count.index], "prefix")
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, lookup(var.public_subnets[count.index], "tags") == null ? {} : lookup(var.public_subnets[count.index], "tags"), { Name = "${lookup(var.public_subnets[count.index], "name")}" })
}

resource "aws_subnet" "private" {
  count                   = length(var.private_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = lookup(var.private_subnets[count.index], "prefix")
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, lookup(var.private_subnets[count.index], "tags") == null ? {} : lookup(var.private_subnets[count.index], "tags"), { Name = "${lookup(var.private_subnets[count.index], "name")}" })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = local.common_tags
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, { Name = "${var.environment_name}-rtb-public" })
}

resource "aws_route_table_association" "public_to_public" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = merge(local.common_tags, { Name = "${var.environment_name}-rtb-default" })
}

resource "aws_eip" "nat_gw" {
  vpc = true

  tags = merge(local.common_tags, { Name = "${var.environment_name}-nat-gw-ip" })
}

resource "random_shuffle" "default_public_subnet" {
  input        = aws_subnet.public[*].id
  result_count = 1
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_gw.id
  subnet_id     = element(random_shuffle.default_public_subnet.result, 0)

  tags = merge(local.common_tags, { Name = "${var.environment_name}-nat-gw" })
}

resource "aws_route" "private_internet_access" {
  route_table_id         = aws_vpc.main.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}
