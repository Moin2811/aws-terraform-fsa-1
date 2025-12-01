# create key pair from local public key file
resource "aws_key_pair" "project_key" {
  key_name   = "${var.project_prefix}-key"
  public_key = file(var.public_key_path)
}

# Jump server SG
resource "aws_security_group" "jump_sg" {
  name   = "${var.project_prefix}-jump-sg"
  vpc_id = var.vpc_id

  ingress {
    description = "SSH (lab) - restrict to your IP in real life"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "jump-sg" }
}

# ALB SG (allow HTTP from internet)
resource "aws_security_group" "alb_sg"{
  name   = "${var.project_prefix}-alb-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress { 
    from_port=0
  to_port=0 
  protocol="-1"
  cidr_blocks=["0.0.0.0/0"] 
  }
}

# App SG (allow HTTP from ALB SG and SSH from Jump SG)
resource "aws_security_group" "app_sg" {
  name   = "${var.project_prefix}-app-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.jump_sg.id]
  }

  egress { 
    from_port=0 
    to_port=0
    protocol="-1"
    cidr_blocks=["0.0.0.0/0"]
    }
}

# Jump instance (public subnet)
resource "aws_instance" "jump" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = element(var.public_subnet_ids, 0)
  associate_public_ip_address = true
  key_name               = aws_key_pair.project_key.key_name
  vpc_security_group_ids = [aws_security_group.jump_sg.id]
  tags = { Name = "jump-server" }
  user_data = file("${path.module}/userdata/jump_userdata.sh")
}

# App instances in private subnets
resource "aws_instance" "app" {
  count                   = 2
  ami                     = var.ami
  instance_type           = var.instance_type
  subnet_id               = element(var.app_private_subnets, count.index)
  associate_public_ip_address = false
  key_name                = aws_key_pair.project_key.key_name
  vpc_security_group_ids  = [aws_security_group.app_sg.id]
  tags = { Name = element(["app-server1","app-server2"], count.index) }

  user_data = templatefile("${path.module}/userdata/app_userdata.tpl",
    {
      rds_endpoint = var.rds_endpoint,
      hostname = element(["app-server1","app-server2"], count.index)
    })
}
