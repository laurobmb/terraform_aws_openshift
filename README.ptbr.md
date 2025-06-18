# Terraform para Infraestrutura de Cluster Privado OpenShift na AWS

Este projeto utiliza o Terraform para provisionar a infraestrutura necessária na AWS para a instalação de um cluster privado do OpenShift Container Platform.

O objetivo é automatizar a criação de recursos de rede e segurança dentro de uma VPC existente, preparando o ambiente para que o instalador do OpenShift possa implantar um cluster que não seja acessível diretamente pela internet.

## Pré-requisitos

Antes de começar, certifique-se de que você possui os seguintes pré-requisitos:

1.  **Conta na AWS**: Com as permissões necessárias para criar os recursos (VPC, Subnets, IAM Roles, Security Groups, etc.).
2.  **AWS CLI Configurada**: Autenticação configurada para que o Terraform possa interagir com sua conta. Você pode fazer isso com `aws configure`.
3.  **Terraform**: [Instalado](https://developer.hashicorp.com/terraform/install) na sua máquina local.
4.  **Pull Secret do OpenShift**: Um [pull secret](https://console.redhat.com/openshift/install/pull-secret) válido da Red Hat para baixar as imagens do OpenShift.
5.  **Uma VPC existente**: Com sub-redes públicas e privadas já criadas na AWS.

## Configuração

### 1. Clonar o Repositório

```bash
git clone <URL_DO_SEU_REPOSITORIO>
cd <NOME_DO_DIRETORIO>
```

### 2. Gerar o Par de Chaves SSH

O instalador do OpenShift precisa de uma chave SSH para acessar os nós do cluster (CoreOS).

```bash
# Este comando cria uma chave privada (id_rsa) e uma pública (id_rsa.pub) no diretório 'ssh/'
ssh-keygen -t rsa -b 4096 -C "aws@redhat.com" -f ssh/id_rsa -N ""
```
**Nota**: O `-N ""` cria a chave sem uma senha (passphrase), o que é comum para automação.

### 3. Configurar Variáveis do Terraform

Crie um arquivo chamado `terraform.tfvars` para fornecer os valores das variáveis necessárias para o seu ambiente. Não versione este arquivo no Git.

**Exemplo de `terraform.tfvars`:**

```hcl
# terraform.tfvars

aws_region           = "us-east-1"
cluster_name         = "meu-cluster-ocp"
vpc_id               = "vpc-0123456789abcdef0"
public_subnet_ids    = ["subnet-012345public", "subnet-678901public"]
private_subnet_ids   = ["subnet-abcdeffprivate", "subnet-fghijkprivate"]
ssh_public_key_path  = "ssh/id_rsa.pub"
```

## Uso do Terraform

Siga os passos abaixo para provisionar e gerenciar a infraestrutura.

### 1. Inicializar o Terraform

Este comando inicializa o diretório de trabalho, baixando os provedores e módulos necessários.

```bash
terraform init
```

### 2. Planejar a Execução

Revise os recursos que o Terraform irá criar, modificar ou destruir. É um passo importante para garantir que as mudanças estão corretas.

```bash
terraform plan
```

### 3. Aplicar as Configurações

Este comando aplica as mudanças e provisiona os recursos na AWS.

```bash
terraform apply -auto-approve
```

### 4. Visualizar as Saídas (Outputs)

Após a criação dos recursos, você pode visualizar informações importantes, como IDs e nomes, que serão usados na configuração do OpenShift (`install-config.yaml`).

```bash
# Exibe as saídas em um formato de tabela legível
terraform output -json | jq -r 'to_entries[] | "\(.key)\t\(.value.value)"' | column -t
```

### 5. Destruir a Infraestrutura

Quando não precisar mais da infraestrutura, você pode removê-la completamente para evitar custos.

```bash
terraform destroy -auto-approve
```

## Recursos Provisionados

Este Terraform irá criar (mas não se limita a):
* **IAM Roles e Policies**: Perfis e políticas de permissão para os nós do cluster (master e worker).
* **Security Groups**: Regras de firewall para controlar o tráfego entre os componentes do cluster e o acesso externo.
* **Route 53 Private Hosted Zone**: Para a resolução de DNS interna do cluster.
* **Elastic Load Balancers (ELB)**: Para a API do cluster e rotas de aplicações.
* Outros recursos de rede necessários para um cluster privado.