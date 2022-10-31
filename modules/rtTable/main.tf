resource "aws_route_table" "table" {
  vpc_id = var.vpc_id

  tags = {
    Environment = var.environment
  }
}

resource "aws_route" "route" {
  route_table_id         = aws_route_table.table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.gateway_id
  nat_gateway_id         = var.nat_gateway_id
}

resource "aws_route_table_association" "route_association" {
  subnet_id      = var.subnet_id
  route_table_id = aws_route_table.table.id
}