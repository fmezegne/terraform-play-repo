#!/bin/bash 
yum update -y 
yum install -y httpd 
systemctl start httpd 
systemctl enable httpd
echo "WELCOME TO FRANCOISE WEBSITE. THIS APPLICATION WAS LUNCHED USING TERRAFORM." >/var/www/html/index.html