output "web_security_group_id" {
  value = aws_security_group.my_security-group.id
}

output "db_security_group_id" {
  value = aws_security_group.database-sec-group.id
}

