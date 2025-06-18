variable "aws_region" {
  description = "Região da AWS para o deploy da infraestrutura."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto para taguear os recursos."
  type        = string
  default     = "openshift-private-cluster"
}

variable "openshift_infra_name" {
  description = "Nome exato da infraestrutura do OpenShift (saída do comando 'oc get infrastructure')."
  type        = string
  # Coloque aqui o nome que o 'oc' retornou oc get infrastructure cluster -o jsonpath='{.status.infrastructureName}'
  default     = "ocp-47t2k" 
}

variable "vpc_cidr" {
  description = "Bloco CIDR para a VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  description = "Lista de blocos CIDR para as sub-redes públicas."
  type        = list(string)
  # 👇 ALTERADO AQUI: 3 blocos CIDR
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets_cidr" {
  description = "Lista de blocos CIDR para as sub-redes privadas."
  type        = list(string)
  # 👇 ALTERADO AQUI: 3 blocos CIDR
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "availability_zones" {
  description = "Lista de Zonas de Disponibilidade para as sub-redes."
  type        = list(string)
  # 👇 ALTERADO AQUI: 3 Zonas de Disponibilidade
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "private_domain_name" {
  description = "Nome do domínio para a zona hospedada privada do Route53."
  type        = string
  default     = "aws.rhbr-labs.local"
}

variable "public_domain_name" {
  description = "Nome do domínio para a zona hospedada publica do Route53."
  type        = string
  default     = "aws.rhbr-labs.com.br"
}

# --- Variáveis para o Bastion Host ---

variable "bastion_instance_type" {
  description = "Tipo da instância EC2 para o bastion host."
  type        = string
  default     = "t3.micro" 
}

variable "bastion_count" {
  description = "Número de instâncias bastion a serem criadas."
  type        = number
  default     = 1
}
# 👇 REMOVA a variável "bastion_key_name"
# variable "bastion_key_name" { ... }

# 👇 ADICIONE esta nova variável
variable "public_key_path" {
  description = "Caminho para o arquivo da sua chave pública SSH (ex: ~/.ssh/id_rsa.pub)."
  type        = string
  default     = "ssh/id_rsa.pub"
}

variable "my_ip" {
  description = "Seu endereço IP público para liberar o acesso SSH ao bastion."
  type        = string
  default     = "0.0.0.0/0" # ATENÇÃO: Troque pelo seu IP! Ex: "200.201.202.203/32"
}

# --- Variável para o Bucket S3 do MinIO ---

variable "s3_minio_bucket_prefix" {
  description = "Prefixo para o nome do bucket S3 que será usado pelo MinIO."
  type        = string
  default     = "minio-backend-storage"
}

