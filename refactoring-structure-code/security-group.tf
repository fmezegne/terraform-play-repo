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
