resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.subnet_id

  tags = {
    Environment = var.environment
  }
}

resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Environment = var.environment
  }
}