# Cria um usuário IAM dedicado para a aplicação MinIO.
resource "aws_iam_user" "minio" {
  name = "${var.project_name}-minio-s3-user"
  path = "/"

  tags = {
    Name    = "${var.project_name}-minio-s3-user"
    Project = var.project_name
  }
}

# Define o documento da política de permissões em formato de dados.
# Isso é mais limpo e seguro do que escrever o JSON diretamente.
data "aws_iam_policy_document" "minio_s3_policy" {
  # Primeira declaração: Permite listar os objetos DENTRO do bucket.
  statement {
    sid = "AllowListBucket"
    actions = [
      "s3:ListBucket",
    ]
    # O recurso é o ARN do bucket em si.
    resources = [
      aws_s3_bucket.minio.arn,
    ]
  }

  # Segunda declaração: Permite ler, escrever e apagar objetos no bucket.
  statement {
    sid = "AllowReadWriteDeleteObjects"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    # O recurso são os OBJETOS DENTRO do bucket (note o "/*" no final).
    resources = [
      "${aws_s3_bucket.minio.arn}/*",
    ]
  }
}

# Cria a política IAM com base no documento definido acima.
resource "aws_iam_policy" "minio" {
  name        = "${var.project_name}-minio-s3-policy"
  description = "Política que permite ler e escrever no bucket S3 do MinIO."
  policy      = data.aws_iam_policy_document.minio_s3_policy.json
}

# Anexa a política criada ao usuário IAM.
resource "aws_iam_user_policy_attachment" "minio" {
  user       = aws_iam_user.minio.name
  policy_arn = aws_iam_policy.minio.arn
}

# Gera as chaves de acesso (Access Key ID e Secret Access Key) para o usuário.
# Estas são as credenciais que sua aplicação MinIO usará.
resource "aws_iam_access_key" "minio" {
  user = aws_iam_user.minio.name
}