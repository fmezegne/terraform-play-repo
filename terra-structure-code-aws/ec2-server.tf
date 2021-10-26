####### create a public EC-2 instance
resource "aws_instance" "pub-ec2" {
  ami = data.aws_ami.aws-linux.id
  instance_type = var.instance_type
  key_name = var.aws_key_pair
  associate_public_ip_address = true
  subnet_id = aws_subnet.terra-pub-sub1.id
  security_groups = [ aws_security_group.terra-web-sg.id ]
  tags = {
    Name = "pub-terra-ec2"
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
    Name = "priv-terra-ec2"
  }
}
