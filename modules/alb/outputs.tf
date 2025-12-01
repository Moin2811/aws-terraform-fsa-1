output "alb_dns" { value = aws_lb.alb.dns_name }
output "app_target_group_arn" { value = aws_lb_target_group.app_tg.arn }
