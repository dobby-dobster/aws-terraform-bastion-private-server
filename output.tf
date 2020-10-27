output "bastion-public-ip" {
  value = aws_instance.bh.public_ip
}

output "private-server-private-ip" {
  value = aws_instance.private_server.private_ip
}
