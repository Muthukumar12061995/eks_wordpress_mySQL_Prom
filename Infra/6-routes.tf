resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
  tags  = {
    Name = "${local.cluster_name}-private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  tags = {
    Name = "${local.cluster_name}-public"
  }
}

resource "aws_route_table_association" "private_zone1" {
    subnet_id = aws_subnet.private_zone1.id
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_zone2" {
    subnet_id = aws_subnet.private_zone2.id
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public_zone1" {
    subnet_id = aws_subnet.public_zone1.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_zone2" {
    subnet_id = aws_subnet.public_zone2.id
    route_table_id = aws_route_table.public.id
}
