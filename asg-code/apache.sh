#!/bin/bash 
yum update -y 
yum install -y httpd 
systemctl start httpd 
systemctl enable httpd
echo "WELCOME TO FRANCOISE WEBSITE. THIS APPLICATION WAS LUNCHED USING AUTOSCALLING." >/var/www/html/index.html