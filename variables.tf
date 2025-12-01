variable "aws_region" {
  type    = string
}

variable "project_prefix" {
  type    = string
}

variable "public_key_path" {
  type    = string
  description = "Absolute path to your public key (e.g. /home/user/.ssh/projectkey.pub)"
}

variable "ami" {
  type = string
  description = "AMI id for EC2 instances in the chosen region (no default -- set in terraform.tfvars)"
}

variable "instance_type" {
  type    = string
}
