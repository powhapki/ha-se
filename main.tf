provider "aws" {
  region = "ap-northeast-2"
}
 
variable "server_port" {
  description = "The Port the server will use for HTTP requests"
  default     = 8080
}

resource "aws_instance" "ha-se-test" {
  ami                    = "ami-067c32f3d5b9ace91"
  instance_type          = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
  EOF

  tags = {
       Name = "hashicorp-se-test"
  }
}

resource "aws_security_group" "instance" {
  name = "ha-se-test-instance"

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
  value = aws_instance.ha-se-test.public_ip
}