provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "web" {
  name        = "WebServer-SG"
  description = "Security Group for Basic WebServer"

  ingress {
    description = "Allow HTTP port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS port"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow ALL ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "WebServer-SG"
    Owner = "Miguel Barboza"
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-0c2b8ca1dad447f8a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = <<EOF
  #!/bin/bash

  yum update -y
  yum install httpd -y

  MYIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
  echo "<h2>WebServer with PrivateIP: $MYIP</h2><br>Built by Terraform" >> /var/www/html/index.html
  service httpd start
  chkconfig httpd on
  EOF

  tags = {
    Name  = "WebServer"
    Owner = "Miguel Barboza"
  }
}
