# Busca a AMI mais recente do Amazon Linux 2023
data "aws_ami" "amazon_linux_2023" {
  # ... (sem alterações) ...
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-*-x86_64"] 
  }
}

# Cria o Key Pair na AWS
resource "aws_key_pair" "bastion_key" {
  # ... (sem alterações) ...
  key_name   = "${var.project_name}-bastion-key"
  public_key = file(var.public_key_path)

  tags = {
    Name = "${var.project_name}-bastion-key"
  }
}

# Cria o Security Group para o Bastion Host
resource "aws_security_group" "bastion" {
  # ... (sem alterações) ...
  name        = "${var.project_name}-bastion-sg"
  description = "Permite acesso SSH ao Bastion Host"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-bastion-sg"
  }
}

# Cria as instâncias EC2 para o Bastion
resource "aws_instance" "bastion" {
  # 👇 ALTERADO: Adiciona o count para criar o número de bastions definido na variável
  count         = var.bastion_count

  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.bastion_instance_type
  key_name      = aws_key_pair.bastion_key.key_name
  
  # 👇 ALTERADO: Coloca cada instância em uma sub-rede pública diferente para HA
  subnet_id     = aws_subnet.public[count.index].id
  
  vpc_security_group_ids = [aws_security_group.bastion.id]
  associate_public_ip_address = true

  tags = {
    # 👇 ALTERADO: Adiciona um sufixo para dar um nome único a cada bastion
    Name = "${var.project_name}-bastion-host-${count.index + 1}"
  }
}