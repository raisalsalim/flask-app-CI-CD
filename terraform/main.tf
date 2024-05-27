provider "aws" {
  region = "ap-south-1"  # Update with your preferred region
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow web traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0f58b397bc5c1f2e8"  # Update with the latest Ubuntu AMI ID for your region
  instance_type = "t2.micro"
  security_groups = [aws_security_group.allow_web.name]
  
  tags = {
    Name = "flask-app-instance"
  }

  key_name = "CI-CD"  # Ensure you have a key pair created in AWS

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y docker.io",
      "sudo systemctl start docker",
      "sudo systemctl enable docker"
    ]
  }
}

output "instance_public_dns" {
  value = aws_instance.web.public_dns
}
