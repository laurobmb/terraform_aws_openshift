# Tabela de Rota para sub-redes públicas
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Associação da tabela de rota pública com as sub-redes públicas
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Tabela de Rota para sub-redes privadas
resource "aws_route_table" "private" {
  count  = length(aws_subnet.private)
  vpc_id = aws_vpc.main.id

  # Rota padrão para a internet via NAT Gateway da sua respectiva AZ
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  # 👇 O BLOCO DE ROTA PARA O S3 ENDPOINT FOI REMOVIDO DAQUI
  # A associação será feita no arquivo vpc.tf

  tags = {
    Name = "${var.project_name}-private-rt-${count.index + 1}"
  }
}

# Associação da tabela de rota privada com as sub-redes privadas
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}