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
