output "endpoint" { value = aws_db_instance.mysql.address }
output "port" { value = aws_db_instance.mysql.port }
output "db_sg_id" { value = aws_security_group.db_sg.id }
