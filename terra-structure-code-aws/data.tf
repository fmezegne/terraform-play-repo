##### data source to have a dynamic ami 
data "aws_ami" "aws-linux" {
  most_recent      = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*.1-x86_64-gp2"]
  } 
  owners = ["amazon"]
}
