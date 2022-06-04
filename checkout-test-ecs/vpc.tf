resource "aws_vpc" "vpc_checkout_ecs" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "vpc-ecs"
  }
}

resource "aws_subnet" "public_subnet_a" {
  availability_zone       = "us-east-1a"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-us-east-1a"
  }

  vpc_id = aws_vpc.vpc_checkout_ecs.id
}

resource "aws_subnet" "private_subnet_a" {
  availability_zone       = "us-east-1a"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-us-east-1a"
  }

  vpc_id= aws_vpc.vpc_checkout_ecs.id
}

resource "aws_internet_gateway" "vpc_checkout_ig" {
  vpc_id = aws_vpc.vpc_checkout_ecs.id
}

resource "aws_route" "internet_access_checkout" {
  route_table_id         = aws_vpc.vpc_checkout_ecs.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc_checkout_ig.id
}

resource "aws_eip" "eip_gateway" {
  count      = 1
  vpc        = true
  depends_on = [aws_internet_gateway.vpc_checkout_ig]
}

resource "aws_nat_gateway" "gateway" {
  count         = 1
  subnet_id     = aws_subnet.public_subnet_a.id
  allocation_id = aws_eip.eip_gateway.id
}

resource "aws_route_table" "private" {
  count  = 1
  vpc_id = aws_vpc.vpc_checkout_ecs.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gateway.id
  }
}

resource "aws_route_table_association" "private" {
  count          = 1
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private.id
}