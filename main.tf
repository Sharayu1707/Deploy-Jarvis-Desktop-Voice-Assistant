resource "aws_security_group" "jarvins_sg" {
  name = "jarvins_sg"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jarvis" {
  ami           = var.my_ami
  instance_type = var.my_instance
  key_name      = var.my_key
  vpc_security_group_ids = [aws_security_group.jarvins_sg.id]
  user_data = file("user_data.sh")

  tags = {
    Name = "jarvis-deploy"
  }
}

