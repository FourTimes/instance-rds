resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Create the public subnet
resource "aws_subnet" "s1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet1-id
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "s2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet2-id
  availability_zone = "${var.region}b"
  map_public_ip_on_launch = true
}


# Create IGW for the public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

# Route the public subnet traffic through the IGW
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Route table and subnet associations
resource "aws_route_table_association" "s1" {
  subnet_id      = aws_subnet.s1.id
  route_table_id = aws_route_table.main.id
}


resource "aws_route_table_association" "s2" {
  subnet_id      = aws_subnet.s2.id
  route_table_id = aws_route_table.main.id
}


