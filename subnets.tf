# Criação das sub-redes públicas
resource "aws_subnet" "public" {
  count             = length(var.public_subnets_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets_cidr[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
    "kubernetes.io/cluster/${var.project_name}" = "shared"
    "kubernetes.io/cluster/${var.openshift_infra_name}" = "shared"   
    "kubernetes.io/role/elb" = "1"
  }
}

# Criação das sub-redes privadas
resource "aws_subnet" "private" {
  count             = length(var.private_subnets_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets_cidr[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.project_name}-private-subnet-${count.index + 1}"
    "kubernetes.io/cluster/${var.project_name}" = "shared"
    "kubernetes.io/cluster/${var.openshift_infra_name}" = "shared"    
    "kubernetes.io/role/internal-elb" = "1"
  }
}