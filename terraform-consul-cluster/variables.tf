# Define the Region
variable "aws_region" {
    default = "ap-northeast-2"
}

# Decide the Availability zone for instance 
variable "instance_az" {
    default = "ap-northeast-2a"
}

# Assingn the Instance Internal IPs
variable "server_instance_ips"{
  type = list
  default = ["172.31.60.101","172.31.60.102","172.31.60.103"]
}

# Define instance key name
variable "instance_key_name" {
    default = "pow_rsa"
}

# Define the AMI 
# Red Hat Enterprise Linux 8 (HVM), SSD Volume Type in ap-northeast-2 - ami-03b72423eaaa8c428" 
# Ubuntu Server 16.04 LTS (HVM), SSD Volume Type - ami-0ab7ae14fe6a99093
# Ubuntu Server 18.04 LTS (HVM), SSD Volume Type - ami-02c9728b733d27242
# Amazon Linux AMI 2018.03.0 (HVM), SSD Volume Type - ami-082b5ca9ff663f3b8
variable "instance_ami_id" {
    default = "ami-0ab7ae14fe6a99093"

}

# Define Instance Type
variable "instance_type" {
    default = "t2.micro"
}
