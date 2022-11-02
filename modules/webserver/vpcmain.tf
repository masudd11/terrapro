resource "aws_vpc" "myvpc" {
  cidr_block           = "10.0.0.0/26"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  tags = {
    "Name" = "myvpc"
  }
}

# creating public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/27"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "public-subnet"
  }
}

# creating private subnet
resource "aws_subnet" "private-subnet" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.32/27"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "private-subnet"
  }
}

# Creating Internet Gateway in AWS VPC
resource "aws_internet_gateway" "firstgateway" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "firstgateway"
  }
}

# Creating Route Tables for Internet gateway
resource "aws_route_table" "first-publicroute" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.firstgateway.id
  }

  tags = {
    Name = "first-publicroute"
  }
}
# Creating Elastic IP
resource "aws_eip" "elasticip" {
  depends_on = [
    aws_internet_gateway.firstgateway
  ]
}
# Creating Nat Gateway
resource "aws_nat_gateway" "natgateway" {
  allocation_id = aws_eip.elasticip.id
  subnet_id     = aws_subnet.public-subnet.id

  tags = {
    Name = "natgateway"
  }
}
# Creating Route Tables for Nat gateway
resource "aws_route_table" "first-privateroute" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgateway.id
  }

  tags = {
    Name = "first-privateroute"
  }
}


# Creating Route Associations public subnets
resource "aws_route_table_association" "first-public-1-a" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.first-publicroute.id
}
# Creating Route Associations private subnets
resource "aws_route_table_association" "first-private-1-a" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.first-privateroute.id
}
