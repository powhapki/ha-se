# CONFIGURE OUR AWS CONNECTION
provider "aws" {
  region = var.aws_region
}

# Select the Default VPC
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# Define the subnet for this tech exercise
resource "aws_subnet" "subnet-hase-cluster" {
  availability_zone = var.instance_az
  vpc_id     = aws_default_vpc.default.id
  cidr_block = "172.31.60.0/24"

  tags = {
    Name = "subnet-hase-cluster"
  }
}

# Define key pair for instance login
#resource "aws_key_pair" "pow_rsa" {
  # Get this vaule from Ubuntu Server after creating the instance 
  #key_name = "pow_rsa"
  #public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDInfmuGQAKM+clveO9AzgiYphT1e5aUYKO+gWEiFi0r8wc/BOm/J8CK8rGZ6QC9GY8zUw73+iAIz09flc5KKKv/IlcX45H3K6+Z8s4gNRv34x59uieLFGPxsb/lfuaJnKv528HgdSk2acqNBIRIkqxIRcp3mTCletbOayK7DjzKK8lk2p5TV0lGoaenV2M8IlzYKjjIgdF6sPz2W+YSzkgZFvFCDh6buzsW1Sw9j0fCHTaglVcwr4szfORv+B4w+31tXEcCLeaMF+a5J2FLA+peW1gjYn4IpXdb2KAh+iLdzdyuHLoeU/9Vk3uzlZp31lseHQ23jh6RoWnv6MgyLZl powhapki@gmail.com"
#}


# DEPLOY Multiple EC2 INSTANCES for consul-cluster
resource "aws_instance" "consul-cluster" {
  ami                    = var.instance_ami_id 
  instance_type          = var.instance_type
  key_name               = var.instance_key_name
  count                  = length(var.server_instance_ips)
  availability_zone      = var.instance_az
  private_ip             = var.server_instance_ips[count.index]
  associate_public_ip_address = true
  subnet_id              = aws_subnet.subnet-hase-cluster.id
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt install git -y
              git clone https://github.com/powhapki/ha-se.git /home/ubuntu/ha-se
              cd /home/ubuntu/ha-se
              chmod 755 inst_consul.sh && sh inst_consul.sh
              chmod 755 config_consul_server.sh && sh config_consul_server.sh
  EOF

  tags = {
    Name = "consul-cluster-${count.index + 1}"
  }
}



# CREATE THE SECURITY GROUP 
resource "aws_security_group" "instance" {
  name = "consul-cluster-asg"

  # Inbound TCP from anywhere
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
