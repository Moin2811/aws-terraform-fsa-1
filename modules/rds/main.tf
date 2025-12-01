resource "aws_db_subnet_group" "dbsub" {
  name       = "db-subnetgroup"
  subnet_ids = var.db_subnet_ids
  tags = { Name = "db-subnetgroup" }
}

resource "aws_security_group" "db_sg" {
  name   = "db-sg"
  vpc_id = var.vpc_id
  description = "Allow DB access from app servers"
  egress { 
    from_port=0
    to_port=0
    protocol="-1"
    cidr_blocks=["0.0.0.0/0"]
    }
}

resource "aws_db_instance" "mysql" {
  identifier = var.db_name
  engine     = "mysql"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  db_name      = var.db_name
  username  = var.username
  password  = var.password
  db_subnet_group_name = aws_db_subnet_group.dbsub.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot = true
  publicly_accessible = false
  multi_az = false
  tags = { Name = var.db_name }
}
