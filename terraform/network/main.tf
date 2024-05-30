resource "aws_vpc" "tp_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "tp_vpc"
  }
}

resource "aws_subnet" "tp_subnet" {
  vpc_id                  = aws_vpc.tp_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.public_subnet_availability_zone

  tags = {
    Name = "tp_subnet"
  }

}

# Create internet gateway to enable instances (EC2) in the VPC to connect to the internet
resource "aws_internet_gateway" "tp_ig" {
  vpc_id = aws_vpc.tp_vpc.id

  tags = {
    Name = "tp_internet_gateway"
  }
}

# Route that directs all traffic (0.0.0.0/0, which means any IP address) to the internet gateway
resource "aws_route_table" "tp_rt" {
  vpc_id = aws_vpc.tp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tp_ig.id
  }

  tags = {
    Name = "tp_route_table"
  }

}

# Associates the route table with the subnet
resource "aws_route_table_association" "tp_rta" {
  subnet_id      = aws_subnet.tp_subnet.id
  route_table_id = aws_route_table.tp_rt.id
}
