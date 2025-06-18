# Terraform para Infraestructura de Cluster Privado de OpenShift en AWS

Este proyecto utiliza Terraform para aprovisionar la infraestructura necesaria en AWS para la instalación de un clúster privado de OpenShift Container Platform.

El objetivo es automatizar la creación de recursos de red y seguridad dentro de una VPC existente, preparando el entorno para que el instalador de OpenShift pueda desplegar un clúster que no sea accesible directamente desde internet.

## Prerrequisitos

Antes de comenzar, asegúrese de que cumple con los siguientes requisitos:

1.  **Cuenta de AWS**: Con los permisos necesarios para crear recursos (VPCs, Subnets, Roles de IAM, Grupos de Seguridad, etc.).
2.  **AWS CLI Configurada**: La autenticación debe estar configurada para que Terraform pueda interactuar con su cuenta. Puede configurarla usando `aws configure`.
3.  **Terraform**: [Instalado](https://developer.hashicorp.com/terraform/install) en su máquina local.
4.  **Pull Secret de OpenShift**: Un [pull secret](https://console.redhat.com/openshift/install/pull-secret) válido de Red Hat para descargar las imágenes de contenedor de OpenShift.
5.  **Una VPC Existente**: Con subredes públicas y privadas ya creadas en AWS.

## Configuración

### 1. Clonar el Repositorio

```bash
git clone <URL_DE_SU_REPOSITORIO>
cd <NOMBRE_DEL_DIRECTORIO>
```

### 2. Generar un Par de Claves SSH

El instalador de OpenShift requiere una clave SSH para acceder a los nodos del clúster (CoreOS).

```bash
# Este comando crea una clave privada (id_rsa) y una pública (id_rsa.pub) en el directorio 'ssh/'
ssh-keygen -t rsa -b 4096 -C "aws@redhat.com" -f ssh/id_rsa -N ""
```
**Nota**: La opción `-N ""` crea la clave sin una frase de contraseña (passphrase), lo cual es común para la automatización.

### 3. Configurar Variables de Terraform

Cree un archivo llamado `terraform.tfvars` para proporcionar los valores de las variables requeridas para su entorno. No versione este archivo en Git.

**Ejemplo de `terraform.tfvars`:**

```hcl
# terraform.tfvars

aws_region           = "us-east-1"
cluster_name         = "mi-cluster-ocp"
vpc_id               = "vpc-0123456789abcdef0"
public_subnet_ids    = ["subnet-012345public", "subnet-678901public"]
private_subnet_ids   = ["subnet-abcdeffprivate", "subnet-fghijkprivate"]
ssh_public_key_path  = "ssh/id_rsa.pub"
```

## Uso de Terraform

Siga los pasos a continuación para aprovisionar y gestionar la infraestructura.

### 1. Inicializar Terraform

Este comando inicializa el directorio de trabajo, descargando los proveedores y módulos necesarios.

```bash
terraform init
```

### 2. Planificar la Ejecución

Revise los recursos que Terraform creará, modificará o destruirá. Este es un paso crucial para asegurarse de que los cambios son correctos.

```bash
terraform plan
```

### 3. Aplicar la Configuración

Este comando aplica los cambios y aprovisiona los recursos en AWS.

```bash
terraform apply -auto-approve
```

### 4. Ver las Salidas (Outputs)

Una vez creados los recursos, puede ver información importante como IDs y nombres. Esta información se utilizará en su archivo `install-config.yaml` de OpenShift.

```bash
# Muestra las salidas en un formato de tabla legible para humanos
terraform output -json | jq -r 'to_entries[] | "\(.key)\t\(.value.value)"' | column -t
```

### 5. Destruir la Infraestructura

Cuando ya no necesite la infraestructura, puede eliminarla por completo para evitar incurrir en costos adicionales.

```bash
terraform destroy -auto-approve
```

## Recursos Aprovisionados

Esta configuración de Terraform creará (pero no se limita a) los siguientes recursos:
* **Roles y Políticas de IAM**: Perfiles y políticas de permisos para los nodos del clúster (master y worker).
* **Grupos de Seguridad (Security Groups)**: Reglas de firewall para controlar el tráfico entre los componentes del clúster y el acceso externo.
* **Zona Hospedada Privada en Route 53**: Para la resolución de DNS interna del clúster.
* **Balanceadores de Carga Elásticos (ELB)**: Para la API del clúster y las rutas de las aplicaciones.
* Otros recursos de red necesarios para un clúster privado.
