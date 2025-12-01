resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = { Name = "${var.project_prefix}-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = { Name = "my-igw" }
}

resource "aws_subnet" "web_pub" {
  count                   = 2
  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(["10.0.1.0/24","10.0.2.0/24"], count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = { Name = element(["web-pub-sub1","web-pub-sub2"], count.index) }
}

resource "aws_subnet" "app_pvt" {
  count             = 2
  vpc_id            = aws_vpc.this.id
  cidr_block        = element(["10.0.3.0/24","10.0.4.0/24"], count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = { Name = element(["app-pvt-sub1","app-pvt-sub2"], count.index) }
}

resource "aws_subnet" "db_pvt" {
  count             = 2
  vpc_id            = aws_vpc.this.id
  cidr_block        = element(["10.0.5.0/24","10.0.6.0/24"], count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = { Name = element(["db-pvt-sub1","db-pvt-sub2"], count.index) }
}

resource "aws_eip" "nat_eip" {
  tags = {
    Name = "my-nat-eip"
  }
}


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.web_pub[0].id
  tags = { Name = "my-nat" }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "route_web" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "route-web" }
}

resource "aws_route_table" "route_app" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = { Name = "route-app" }
}

resource "aws_route_table" "route_db" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = { Name = "route-db" }
}

resource "aws_route_table_association" "web_assoc" {
  count          = length(aws_subnet.web_pub)
  subnet_id      = aws_subnet.web_pub[count.index].id
  route_table_id = aws_route_table.route_web.id
}

resource "aws_route_table_association" "app_assoc" {
  count          = length(aws_subnet.app_pvt)
  subnet_id      = aws_subnet.app_pvt[count.index].id
  route_table_id = aws_route_table.route_app.id
}

resource "aws_route_table_association" "db_assoc" {
  count          = length(aws_subnet.db_pvt)
  subnet_id      = aws_subnet.db_pvt[count.index].id
  route_table_id = aws_route_table.route_db.id
}
