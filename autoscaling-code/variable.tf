###### define variable that we will reference on resources work like parameters in cloudformation
variable "region" {
  description = "create a variavle for region that we will reference"
  type = string
  default = "us-east-1"  
}

variable "aws_key_pair" {
  description = "creating a variable to hold an existing key pair name on my account"
  type = string
  default = "francoise-key-pair"  
}

variable "cidr_block-vpc" {
  description = "creating a variable to hold a cidr_block of my vpc on my account"
  type = string
  default = "10.0.0.0/16"
}

variable "cidr_block_pub" {
  description = "creating a variable to hold a cidr_block of my public subnet on my account"
  type = list(string)
  default = ["10.0.0.0/24","10.0.1.0/24"]
}

variable "cidr_block_mypublic_ip" {
  description = "my public ip address"
  type = string
  default = "72.83.17.230/32"
}

##### variable list
variable "availability_zone" {
  description = "list of availability zone for my subnets"
  type = list(string)
  default = ["us-east-1a","us-east-1b"]  
}

#### variable map
variable "instance_type_map" {
    type = map(string)
    default = {
      "hands-on" = "t2.micro"
      "test" = "t2.small"
      "prod" = "t2.large"
    }  
}

###### variable for string interpolation
variable "pub-subnet-rename" {
    description = "renaming my public subnet to make it more dynamic"
    type = string
    default = "pub-subnet"
}

###### variable for string interpolation
variable "asg-ec2-name" {
    description = "renaming my ec2-server to make it more dynamic"
    type = string
    default = "pub-ec2"
}