output "subnet_id" {
  value = aws_subnet.subnet.id
}

output "is_public" {
  value = var.is_public
}
