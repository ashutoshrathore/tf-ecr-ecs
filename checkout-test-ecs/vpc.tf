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
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-us-east-1a"
  }

  vpc_id= aws_vpc.vpc_checkout_ecs.id
}

resource "aws_subnet" "private_subnet_b" {
  availability_zone       = "us-east-1b"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-us-east-1b"
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
  vpc        = true
  depends_on = [aws_internet_gateway.vpc_checkout_ig]
}

resource "aws_nat_gateway" "gateway" {
  subnet_id     = aws_subnet.public_subnet_a.id
  allocation_id = aws_eip.eip_gateway.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc_checkout_ecs.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gateway.id
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = [aws_subnet.private_subnet_a.id]
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = [aws_subnet.private_subnet_b.id]
  route_table_id = aws_route_table.private.id
}