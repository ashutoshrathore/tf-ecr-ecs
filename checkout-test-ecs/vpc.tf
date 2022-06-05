resource "aws_vpc" "vpc_checkout_ecs" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "vpc-ecs"
  }
}

resource "aws_subnet" "public_subnet_a" {
  availability_zone       = var.azs[1]
  cidr_block              = var.pub_subnet_1_cidr
  map_public_ip_on_launch = true
  vpc_id = aws_vpc.vpc_checkout_ecs.id

  tags = {
    Name = "public-us-east-1a"
  }
}

resource "aws_subnet" "public_subnet_b" {
  availability_zone       = var.azs[2]
  cidr_block              = var.pub_subnet_2_cidr
  map_public_ip_on_launch = true
  vpc_id = aws_vpc.vpc_checkout_ecs.id

  tags = {
    Name = "public-us-east-1b"
  }
}



resource "aws_subnet" "private_subnet_a" {
  availability_zone       = var.azs[1]
  cidr_block              = var.pvt_subnet_1_cidr
  map_public_ip_on_launch = false
  vpc_id= aws_vpc.vpc_checkout_ecs.id

  tags = {
    Name = "private-us-east-1a"
  }
}

resource "aws_subnet" "private_subnet_b" {
  availability_zone       = var.azs[2]
  cidr_block              = var.pvt_subnet_2_cidr
  map_public_ip_on_launch = false
  vpc_id= aws_vpc.vpc_checkout_ecs.id

  tags = {
    Name = "private-us-east-1b"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc_checkout_ecs.id
}
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc_checkout_ecs.id
}


resource "aws_route_table_association" "public-route-1-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public_subnet_a.id
}
resource "aws_route_table_association" "public-route-2-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public_subnet_b.id
}
resource "aws_route_table_association" "private-route-1-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private_subnet_a.id
}
resource "aws_route_table_association" "private-route-2-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private_subnet_b.id
}


resource "aws_eip" "eip_gateway" {
  vpc        = true
  associate_with_private_ip = "10.0.0.5"
  depends_on = [aws_internet_gateway.vpc_checkout_ig]
}

resource "aws_internet_gateway" "vpc_checkout_ig" {
  vpc_id = aws_vpc.vpc_checkout_ecs.id
}

resource "aws_nat_gateway" "nat_gateway" {
  subnet_id     = aws_subnet.public_subnet_a.id
  allocation_id = aws_eip.eip_gateway.id
  depends_on    = [aws_eip.eip_gateway]
}

resource "aws_route" "nat-gateway-route" {
  route_table_id         = aws_route_table.private-route-table.id
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "internet_access_checkout" {
  route_table_id         = aws_route_table.public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc_checkout_ig.id
}

