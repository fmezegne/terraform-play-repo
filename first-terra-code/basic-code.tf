# Configure the AWS Provider
provider "aws" {
  region = var.region
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
    Name = "terraform-pub-route"
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
####### create a public EC-2 instance
resource "aws_instance" "pub-ec2" {
  ami = data.aws_ami.aws-linux.id
  instance_type = var.instance_type
  key_name = var.aws_key_pair
  associate_public_ip_address = true
  subnet_id = aws_subnet.terra-pub-sub1.id
  security_groups = [ aws_security_group.terra-web-sg.id ]
  tags = {
    Name = "public-terra-ec2"
  }
}
####### create a private EC-2 instance
resource "aws_instance" "priv-ec2" {
  ami = data.aws_ami.aws-linux.id
  instance_type = var.instance_type
  key_name = var.aws_key_pair
  subnet_id = aws_subnet.terra-priv-sub1.id
  security_groups = [ aws_security_group.terra-web-sg.id ]
  tags = {
    Name = "private-terra-ec2"
  }
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
###### define variable that we will reference on resources work like parameters in cloudformation
variable "region" {
  description = "create a variavle for region that we will reference"
  type = string
  default = "us-east-1"  
}

variable "instance_type" {
  description = "type of instance for our EC2"
  type = string
  default = "t2.micro"  
}

variable "aws_key_pair" {
  description = "creating a variable to hold an existing key pair name on my account"
  type = string
  default = "francoise-key-pair"  
}

variable "availability_zone" {
  description = "creating a variable to hold an availability_zone on my account"
  type = string
  default = "us-east-1a"  
}

variable "cidr_block-vpc" {
  description = "creating a variable to hold a cidr_block of my vpc on my account"
  type = string
  default = "10.0.0.0/16"
}

variable "cidr_block-pub" {
  description = "creating a variable to hold a cidr_block of my public subnet on my account"
  type = string
  default = "10.0.0.0/24"
}

variable "cidr_block-priv" {
  description = "creating a variable to hold a cidr_block of my private subnet on my account"
  type = string
  default = "10.0.1.0/24"
}

variable "cidr_block_mypublic_ip" {
  description = "my public ip address"
  type = string
  default = "72.83.17.230/32"
}

#######OUTPUTS SECTION
output "instance-pub-ip" {
  description = "display ip address of my public instance"
  value = aws_instance.pub-ec2.public_ip 
}

output "instance-priv-ip" {
  description = "display private ip address of my private instance"
  value = aws_instance.priv-ec2.private_ip  
}

output "instance-dns" {
  description = "display dns name of your pub instance"
  value = aws_instance.pub-ec2.public_dns  
}
