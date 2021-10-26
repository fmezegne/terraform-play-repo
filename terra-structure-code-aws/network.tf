# Create a VPC
resource "aws_vpc" "terra-vpc" {
  cidr_block = var.cidr_block-vpc
  tags = {
    Name = "terra-vpc"
  }
  enable_dns_hostnames = true
  enable_dns_support = true
}
#####create public subnet
resource "aws_subnet" "terra-pub-sub1" {
  availability_zone = var.availability_zone
  vpc_id = aws_vpc.terra-vpc.id
  cidr_block = var.cidr_block-pub
  tags = {
    Name = "terra-pub-sub1"
  }
}
#####create private subnet
resource "aws_subnet" "terra-priv-sub1" {
  availability_zone = var.availability_zone
  vpc_id = aws_vpc.terra-vpc.id
  cidr_block = var.cidr_block-priv
  tags = {
    Name = "terra-priv-sub1"
  }
}
####### create an internet gateway
resource "aws_internet_gateway" "terra-igw" {
  vpc_id = aws_vpc.terra-vpc.id 
}
#### create public route table
resource "aws_route_table" "terra-pub-route" {
  vpc_id = aws_vpc.terra-vpc.id
  
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra-igw.id
  } 
  tags = {
    Name = "terra-pub-route"
  }  
}
######associate route table to public subnet
resource "aws_route_table_association" "terra-pub-route-association" {
  subnet_id = aws_subnet.terra-pub-sub1.id
  route_table_id = aws_route_table.terra-pub-route.id 
}
#### create private route table
resource "aws_route_table" "terra-priv-route" {
  vpc_id = aws_vpc.terra-vpc.id
  tags = {
    Name = "terra-priv-route"
  }  
}
######associate route table to rivate subnet
resource "aws_route_table_association" "terra-priv-route-association" {
  subnet_id = aws_subnet.terra-priv-sub1.id
  route_table_id = aws_route_table.terra-priv-route.id
}
