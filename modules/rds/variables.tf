variable "vpc_id" {}

variable "db_subnet_ids" {
  type = list(string)
}

variable "db_name" {
  type    = string
  default = "mydbproject"
}

variable "username" {
  type    = string
  default = "admin"
}

variable "password" {
  type      = string
  sensitive = true
  default   = "admin1234"
}
