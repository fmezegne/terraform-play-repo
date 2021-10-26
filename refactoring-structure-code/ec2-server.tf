####### create a public EC-2 instance
resource "aws_instance" "pub-ec2" {
  ami = data.aws_ami.aws-linux.id
  instance_type = var.instance_type
  count = 2                          ### this is calles meta argument useful when you want to duplicate same ressources
  key_name = var.aws_key_pair
  associate_public_ip_address = true
  subnet_id = aws_subnet.terra-pub-sub1.id
  security_groups = [ aws_security_group.terra-web-sg.id ]
  user_data = file("apache.sh")     ### meta argument called file function that allow you to pass a file located in same folder as your code config file
  tags = {
    Name = "terra-${var.ec2-rename}-${count.index}"  ## ref string interpolation variable to make name of instance more dynamic. 
  }
}
####### create a private EC-2 instance
resource "aws_instance" "priv-ec2" {
  ami = data.aws_ami.aws-linux.id
#   instance_type = var.instance_type_list[0]         ## ref variable list
  instance_type = var.instance_type_map["test"]       ## ref variable map
  key_name = var.aws_key_pair
  subnet_id = aws_subnet.terra-priv-sub1.id
  security_groups = [ aws_security_group.terra-web-sg.id ]
  tags = {
    Name = "priv-terra-ec2"
  }
}
