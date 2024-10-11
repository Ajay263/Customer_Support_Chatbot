output "instance_public_ip" {
  value = aws_instance.rag_cs_instance.public_ip
}

output "instance_public_dns" {
  value = aws_instance.rag_cs_instance.public_dns
}