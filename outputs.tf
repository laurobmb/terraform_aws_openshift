output "vpc_id" {
  description = "ID da VPC criada."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Lista de IDs das sub-redes públicas."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Lista de IDs das sub-redes privadas."
  value       = aws_subnet.private[*].id
}

output "aws_region" {
  description = "Região da AWS onde a infraestrutura foi criada."
  value       = var.aws_region
}

output "vpc_cidr_block" {
  description = "Bloco de endereço de rede (CIDR) da VPC."
  value       = aws_vpc.main.cidr_block
}

output "availability_zones_used" {
  description = "Zonas de Disponibilidade utilizadas no deploy."
  value       = var.availability_zones
}

# 👇 ADICIONE ESTES BLOCOS
output "route53_zone_id" {
  description = "ID da Zona Hospedada Privada do Route53."
  value       = aws_route53_zone.private.id
}

output "route53_private_zone_name_servers" {
  description = "Lista de Name Servers (NS) da zona private. Use estes valores para atualizar seu registrador de domínio (ex: Registro.br)."
  value       = aws_route53_zone.private.name_servers
}

output "route53_zone_private_name" {
  description = "Nome da Zona Hospedada Privada do Route53."
  value       = aws_route53_zone.private.name
}

# 👇 ADICIONE ESTES BLOCOS PARA A ZONA PÚBLICA
output "route53_public_zone_id" {
  description = "ID da Zona Hospedada Pública do Route53."
  value       = aws_route53_zone.public.id
}

output "route53_public_zone_name_servers" {
  description = "Lista de Name Servers (NS) da zona pública. Use estes valores para atualizar seu registrador de domínio (ex: Registro.br)."
  value       = aws_route53_zone.public.name_servers
}

output "route53_zone_public_name" {
  description = "Nome da Zona Hospedada Publica do Route53."
  value       = aws_route53_zone.public.name
}
# --- Saída para o Bastion Host ---

output "bastion_public_ips" { # <-- Renomeado para o plural para clareza
  description = "Lista de endereços IP públicos dos Bastion Hosts."
  # 👇 ALTERADO: Usa o 'splat expression' (*) para obter o IP de TODAS as instâncias
  value       = aws_instance.bastion[*].public_ip
}
# --- Saída para o Bucket S3 do MinIO ---

output "minio_s3_bucket_name" {
  description = "O nome do bucket S3 criado para o backend do MinIO."
  value       = aws_s3_bucket.minio.id
}

# --- Saídas para o Usuário IAM do MinIO ---

output "minio_user_access_key_id" {
  description = "Access Key ID para o usuário do MinIO. Use esta na sua aplicação."
  value       = aws_iam_access_key.minio.id
}

output "minio_user_secret_access_key" {
  description = "Secret Access Key para o usuário do MinIO. Use esta na sua aplicação."
  value       = aws_iam_access_key.minio.secret
  # 'sensitive = true' impede que o Terraform mostre este valor no console durante o 'apply'.
  # Você ainda pode acessá-lo com o comando 'terraform output'.
  sensitive   = true 
}

output "s3_bucket_endpoint_url" {
  description = "A URL de endpoint regional do bucket S3 (ex: s3.us-east-1.amazonaws.com)."
  value       = "s3.${var.aws_region}.amazonaws.com"
}

output "s3_bucket_specific_url" {
  description = "A URL completa e específica do bucket S3."
  value       = "https://s3.${var.aws_region}.amazonaws.com/${aws_s3_bucket.minio.id}"
}

output "s3_bucket_regional_domain_name" {
  description = "O nome de domínio regional do bucket, usado por SDKs (bucket.s3.region.amazonaws.com)."
  value       = aws_s3_bucket.minio.bucket_regional_domain_name
}