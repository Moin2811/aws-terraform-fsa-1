output "alb_dns" { value = module.alb.alb_dns }
output "rds_endpoint" { value = module.rds.endpoint }
output "jump_public_ip" { value = module.compute.jump_public_ip }
output "app_private_ips" { value = module.compute.app_private_ips }
output "key_name" { value = module.compute.key_name }
