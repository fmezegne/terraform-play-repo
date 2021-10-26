# Configure the AWS Provider
provider "aws" {
  region = var.region
}

##### data source to have a dynamic ami 
data "aws_ami" "aws-linux" {
  most_recent      = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*.1-x86_64-gp2"]
  } 
  owners = ["amazon"]
}

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
resource "aws_subnet" "terra-pub-sub" {
  availability_zone = element(var.availability_zone,count.index)
  count = length(var.cidr_block_pub)        #### length is a function that determines the length of a given list, map, or string.eg:If given a list or map, the result is the number of elements in that collection 
  # count = 2
  vpc_id = aws_vpc.terra-vpc.id
  cidr_block = element(var.cidr_block_pub,count.index)
  tags = {
    Name = "terra-${var.pub-subnet-rename}-${count.index}"
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
  count = 2
  subnet_id = element(aws_subnet.terra-pub-sub.*.id,count.index)
  route_table_id = aws_route_table.terra-pub-route.id 
}

########create security group for puclic instances
resource "aws_security_group" "terra-web-sg" {
  description = "allow port 80 and 22"
  vpc_id = aws_vpc.terra-vpc.id
  ingress  {
    cidr_blocks = [ var.cidr_block_mypublic_ip ]
    description = "allow port 22"
    from_port = 22
    protocol = "tcp"
    to_port = 22
  }
  ingress  {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "allow port 80"
    from_port = 80
    protocol = "tcp"
    to_port = 80
  } 
  
  egress  {
    
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  tags = {
    "Name" = "terra-web-sg"
  }
}

# ##### launch configuration
resource "aws_launch_configuration" "launch-config" {
  name = "launch-config"
  associate_public_ip_address = true
  image_id = data.aws_ami.aws-linux.id
  instance_type = var.instance_type_map["hands-on"]
  key_name = var.aws_key_pair
  security_groups = [aws_security_group.terra-web-sg.id]
  user_data = file("apache.sh")
}

# ###### Auto csalling group
resource "aws_autoscaling_group" "asg" {
  name = "terra-asg"
  desired_capacity = 2
  min_size = 2
  max_size = 3
  launch_configuration = aws_launch_configuration.launch-config.name
  vpc_zone_identifier = aws_subnet.terra-pub-sub.*.id
  # availability_zones = var.availability_zone.*
}
