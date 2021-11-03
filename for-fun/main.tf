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