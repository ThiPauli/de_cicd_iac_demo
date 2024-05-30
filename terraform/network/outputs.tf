output "vpc_id" {
  value = aws_vpc.tp_vpc.id
}

output "subnet_id" {
  value = aws_subnet.tp_subnet.id
}
