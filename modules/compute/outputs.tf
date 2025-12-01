output "jump_public_ip" { value = aws_instance.jump.public_ip }
output "app_private_ips" { value = aws_instance.app[*].private_ip }
output "app_instance_ids" { value = aws_instance.app[*].id }
output "alb_sg_id" { value = aws_security_group.alb_sg.id }
output "app_sg_id" { value = aws_security_group.app_sg.id }
output "jump_sg_id" { value = aws_security_group.jump_sg.id }
output "key_name" { value = aws_key_pair.project_key.key_name }
