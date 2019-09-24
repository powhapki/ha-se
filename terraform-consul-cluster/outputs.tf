output "Consul_Cluster_instance_public_ip" {
  value = aws_instance.consul-cluster[*].public_ip
}