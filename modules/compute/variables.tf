variable "project_prefix" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "app_private_subnets" { type = list(string) }
variable "vpc_id" { type = string }
variable "ami" { type = string }
variable "instance_type" { type = string }
variable "public_key_path" { type = string }
variable "rds_endpoint" {
     type = string
     default = "" 
     }
