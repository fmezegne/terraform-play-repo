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