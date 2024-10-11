output "vpc_id" {
  value = aws_vpc.rag_cs_vpc.id
}

output "subnet_id" {
  value = aws_subnet.rag_cs_subnet.id
}