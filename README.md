Three-tier Terraform project (VPC / EC2 / ALB / RDS)

Steps:
1. Edit terraform.tfvars (set public_key_path to absolute path and ami to a valid AMI).
2. Ensure AWS credentials are set (AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY or aws configure).
3. terraform init
4. terraform plan -out plan.tfplan
5. terraform apply "plan.tfplan"
6. After apply: terraform output alb_dns, jump_public_ip, rds_endpoint
7. SSH into jump server: ssh -i ~/.ssh/projectkey ec2-user@<jump_ip>
8. From jump: ssh -i ~/projectkey ec2-user@<app_private_ip>
