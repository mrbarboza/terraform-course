#!/bin/bash

yum update -y
yum install httpd -y

MYIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with PrivateIP: $MYIP</h2><br>Built by Terraform external File" >> /var/www/html/index.html
service httpd start
chkconfig httpd on