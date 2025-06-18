# --- ZONA PRIVADA (Já existente) ---
# Cria a Zona Hospedada Privada no Route 53
resource "aws_route53_zone" "private" {
  name = var.private_domain_name

  vpc {
    vpc_id = aws_vpc.main.id
  }

  comment = "Zona privada para o cluster OpenShift"

  tags = {
    Name = "${var.project_name}-private-zone"
  }
}


# --- ZONA PÚBLICA (Nova) ---
# Cria a Zona Hospedada Pública no Route 53
resource "aws_route53_zone" "public" {
  # Usa o nome do domínio público definido na variável
  name = var.public_domain_name

  # A ausência do bloco "vpc" indica que esta é uma zona pública.
  comment = "Zona pública para o cluster OpenShift"

  tags = {
    Name = "${var.project_name}-public-zone"
  }
}