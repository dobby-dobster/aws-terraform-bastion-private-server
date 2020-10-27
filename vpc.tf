#Create  vpc
resource "aws_vpc" "vpc" {
  provider             = aws
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc"
  }
}

#Create IGW in vpc used by public subnet
resource "aws_internet_gateway" "igw" {
  provider = aws
  vpc_id   = aws_vpc.vpc.id
  tags = {
    Name = "Internet Gateway"
  }
}

#Get all available AZ's in VPC for  region
data "aws_availability_zones" "azs" {
  provider = aws
  state    = "available"
}

#Create subnet #1 in  vpc
resource "aws_subnet" "private_subnet" {
  provider          = aws
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr
  tags = {
    Name = "Private Subnet"
  }
}

#Create subnet #2 in  vpc
resource "aws_subnet" "public_subnet" {
  provider                = aws
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = element(data.aws_availability_zones.azs.names, 0)
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet"
  }
}

#Create route table in vpc
resource "aws_route_table" "route_table" {
  provider = aws
  vpc_id   = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "Route Table"
  }
}

# associate the route table to the public subent to allow public subnet to route via IGW
resource "aws_route_table_association" "associate_public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.route_table.id
}

