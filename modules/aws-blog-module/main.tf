resource "aws_vpc" "project_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "project-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  count = 3

  vpc_id                  = aws_vpc.project_vpc.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count = 3

  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "PrivateSubnet-${count.index + 1}"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.project_vpc.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.project_vpc.id
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.project_igw.id
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.project_nat_gw.id
}

resource "aws_route_table_association" "public_route_table_association" {
  count          = 3
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = 3
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_internet_gateway" "project_igw" {
  vpc_id = aws_vpc.project_vpc.id
}

resource "aws_nat_gateway" "project_nat_gw" {
  allocation_id = aws_eip.project_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id
}

resource "aws_eip" "project_eip" {

}
