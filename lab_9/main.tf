provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web-server" {
  ami                    = "ami-0c2b8ca1dad447f8a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.general.id]

  tags = {
    Name  = "Web Server"
    Owner = "Miguel Barboza"
  }

  depends_on = [
    aws_instance.db-server,
    aws_instance.app-server
  ]
}

resource "aws_instance" "app-server" {
  ami                    = "ami-0c2b8ca1dad447f8a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.general.id]

  tags = {
    Name  = "App Server"
    Owner = "Miguel Barboza"
  }

  depends_on = [
    aws_instance.db-server
  ]
}

resource "aws_instance" "db-server" {
  ami                    = "ami-0c2b8ca1dad447f8a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.general.id]

  tags = {
    Name  = "DB Server"
    Owner = "Miguel Barboza"
  }
}

resource "aws_security_group" "general" {
  name        = "general-sg"
  description = "general security group"

  dynamic "ingress" {
    for_each = ["80", "443", "22", "3389"]
    content {
      description = "Allow HTTP port"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    description = "Allow ALL ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "general-sg"
    Owner = "Miguel Barboza"
  }
}
