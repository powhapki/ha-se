# CONFIGURE OUR AWS CONNECTION
provider "aws" {
  region = var.aws_region
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# Using existing Subnet
data "aws_subnet" "selected" {
  filter {
    name   = "tag:Name"
    values = ["subnet-hase-cluster"]       
  }
}


# DEPLOY Multiple EC2 INSTANCES for Vault
resource "aws_instance" "vault-cluster" {
  ami                    = var.instance_ami_id 
  instance_type          = var.instance_type
  key_name               = var.instance_key_name
  count                  = length(var.server_instance_ips)
  availability_zone      = var.instance_az
  private_ip             = var.server_instance_ips[count.index]
  associate_public_ip_address = true
  subnet_id              = data.aws_subnet.selected.id
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt install git postgresql-client-common postgresql-client-* -y
              git clone https://github.com/powhapki/ha-se.git /home/ubuntu/ha-se
              cd /home/ubuntu/ha-se
              chmod 755 inst_consul.sh && sh inst_consul.sh
              chmod 755 config_consul_agent.sh && sh config_consul_agent.sh
              chmod 755 inst_vault.sh && sh inst_vault.sh
              chmod 755 config_vault_server.sh && sh config_vault_server.sh
              #output : { all : '| tee -a /var/log/cloud-init-output.log' }
EOF


  tags = {
    Name = "vault-cluster-${count.index + 1}"
  }
}



# CREATE THE SECURITY GROUP THAT'S APPLIED TO THE EC2 INSTANCE


resource "aws_security_group" "instance" {
  name = "vault-cluster-asg"

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

