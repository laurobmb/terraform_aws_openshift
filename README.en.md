# Terraform for AWS OpenShift Private Cluster Infrastructure

This project uses Terraform to provision the necessary infrastructure on AWS for installing a private OpenShift Container Platform cluster.

The goal is to automate the creation of networking and security resources within an existing VPC, preparing the environment for the OpenShift installer to deploy a cluster that is not directly accessible from the internet.

## Prerequisites

Before you begin, ensure you have the following:

1.  **AWS Account**: With the necessary permissions to create resources (VPCs, Subnets, IAM Roles, Security Groups, etc.).
2.  **Configured AWS CLI**: Authentication must be configured so Terraform can interact with your account. You can set this up using `aws configure`.
3.  **Terraform**: [Installed](https://developer.hashicorp.com/terraform/install) on your local machine.
4.  **OpenShift Pull Secret**: A valid [pull secret](https://console.redhat.com/openshift/install/pull-secret) from Red Hat to download OpenShift container images.
5.  **An Existing VPC**: With pre-existing public and private subnets on AWS.

## Setup

### 1. Clone the Repository

```bash
git clone <YOUR_REPOSITORY_URL>
cd <REPOSITORY_DIRECTORY>
```

### 2. Generate an SSH Key Pair

The OpenShift installer requires an SSH key to access the cluster nodes (CoreOS).

```bash
# This command creates a private key (id_rsa) and a public key (id_rsa.pub) in the 'ssh/' directory
ssh-keygen -t rsa -b 4096 -C "aws@redhat.com" -f ssh/id_rsa -N ""
```
**Note**: The `-N ""` flag creates the key without a passphrase, which is common for automation.

### 3. Configure Terraform Variables

Create a file named `terraform.tfvars` to provide the required variable values for your environment. Do not commit this file to version control.

**Example `terraform.tfvars`:**

```hcl
# terraform.tfvars

aws_region           = "us-east-1"
cluster_name         = "my-ocp-cluster"
vpc_id               = "vpc-0123456789abcdef0"
public_subnet_ids    = ["subnet-012345public", "subnet-678901public"]
private_subnet_ids   = ["subnet-abcdeffprivate", "subnet-fghijkprivate"]
ssh_public_key_path  = "ssh/id_rsa.pub"
```

## Terraform Usage

Follow the steps below to provision and manage the infrastructure.

### 1. Initialize Terraform

This command initializes the working directory, downloading the necessary providers and modules.

```bash
terraform init
```

### 2. Plan the Execution

Review the resources that Terraform will create, modify, or destroy. This is a crucial step to ensure the changes are correct.

```bash
terraform plan
```

### 3. Apply the Configuration

This command applies the changes and provisions the resources on AWS.

```bash
terraform apply -auto-approve
```

### 4. View Outputs

After the resources are created, you can view important information like IDs and names. This output will be used in your OpenShift `install-config.yaml` file.

```bash
# Displays the outputs in a human-readable table format
terraform output -json | jq -r 'to_entries[] | "\(.key)\t\(.value.value)"' | column -t
```

### 5. Destroy the Infrastructure

When you no longer need the infrastructure, you can completely remove it to avoid incurring further costs.

```bash
terraform destroy -auto-approve
```

## Provisioned Resources

This Terraform configuration will create (but is not limited to) the following resources:
* **IAM Roles and Policies**: Roles and permissions policies for the cluster nodes (master and worker).
* **Security Groups**: Firewall rules to control traffic between cluster components and external access.
* **Route 53 Private Hosted Zone**: For the cluster's internal DNS resolution.
* **Elastic Load Balancers (ELB)**: For the cluster API and application routes.
* Other networking resources required for a private cluster.