# Obtém informações sobre a conta AWS atual, como o ID da conta.
# Usaremos o ID da conta para garantir que o nome do bucket seja único globalmente.
data "aws_caller_identity" "current" {}

# Recurso principal que cria o bucket S3.
resource "aws_s3_bucket" "minio" {
  # Concatena o prefixo com o ID da conta para criar um nome único.
  bucket = "${var.s3_minio_bucket_prefix}-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name    = "${var.project_name}-minio-bucket"
    Project = var.project_name
  }
}

# Habilita o versionamento no bucket.
# Isso protege contra a sobrescrita ou exclusão acidental de arquivos.
resource "aws_s3_bucket_versioning" "minio" {
  bucket = aws_s3_bucket.minio.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Bloqueia todo o acesso público ao bucket.
# Esta é uma configuração de segurança CRÍTICA.
resource "aws_s3_bucket_public_access_block" "minio" {
  bucket = aws_s3_bucket.minio.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Define a política de criptografia padrão para o bucket.
# Todos os objetos enviados serão criptografados com chaves gerenciadas pela AWS (AES256).
resource "aws_s3_bucket_server_side_encryption_configuration" "minio" {
  bucket = aws_s3_bucket.minio.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}