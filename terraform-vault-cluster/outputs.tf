output "Vault_Server_Public_IP" {
  value = aws_instance.vault-cluster[*].public_ip
}