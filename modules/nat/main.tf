resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.subnet_id

  tags = {
    Environment = var.environment
  }
  depends_on = [aws_eip.nat]
}

resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Environment = var.environment
  }
}