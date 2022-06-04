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

resource "aws_subnet" "public_subnet_b" {
  availability_zone       = "us-east-1b"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-us-east-1b"
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

resource "aws_subnet" "private_subnet_b" {
  availability_zone       = "us-east-1b"
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-us-east-1b"
  }

  vpc_id= aws_vpc.vpc_checkout_ecs.id
}

resource "aws_internet_gateway" "vpc_checkout_ig" {
  vpc_id = aws_vpc.vpc_checkout_ecs.id

  tags = {
    Name = "internet-gateway"
  }
}

resource "aws_route_table" "public-ig" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_checkout_ig.id
  }

  tags = {
    Name = "route-table-public-ig"
  }
  vpc_id = aws_vpc.vpc_checkout_ecs.id
}

resource "aws_route_table_association" "public_route_a" {
  route_table_id = aws_route_table.public-ig.id
  subnet_id      = aws_subnet.public_subnet_a.id
}

resource "aws_route_table_association" "public_route_b" {
  route_table_id = aws_route_table.public-ig.id
  subnet_id      = aws_subnet.public_subnet_b.id
}

resource "aws_main_route_table_association" "main_route" {
  route_table_id = aws_route_table.public-ig.id
  vpc_id         = aws_vpc.vpc_checkout_ecs.id
}

