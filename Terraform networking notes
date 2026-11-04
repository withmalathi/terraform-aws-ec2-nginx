# AWS Networking – Terraform Configuration and Commands

**Repository:** `terraform-aws-ec2-nginx`  
**Local path:** `~/projects/terraform-aws-ec2-nginx`  
**AWS Region:** `us-west-2`  
**AWS CLI Profile:** `ec2-nginx-lab`

This document explains how the networking configuration is defined and applied through Terraform.

For this project:

- We discover the existing default VPC using a data source.
- We reuse the existing subnet.
- We create a new Terraform-managed security group.
- We attach that security group to the new EC2 instance.
- We do not create a new VPC, subnet, route table or Internet Gateway.

## 1. Open the Terraform repository

```bash
cd ~/projects/terraform-aws-ec2-nginx
```

## 2. Understand which files contain the networking configuration

| Filename | Responsibility |
|---|---|
| `versions.tf` | Configures Terraform requirements, AWS provider, region and profile |
| `main.tf` | Defines the existing VPC data source, security group and EC2 resource |
| `variables.tf` | Declares the SSH CIDR input variable |
| `terraform.tfvars` | Supplies the actual trusted SSH CIDR value |
| `outputs.tf` | Defines useful deployment outputs |
| `.gitignore` | Excludes local and sensitive Terraform files |

We do not execute each `.tf` file separately. Terraform reads the configuration files in the project directory together.

## 3. versions.tf – AWS provider configuration

**File:** `versions.tf`

The project uses this configuration:

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "us-west-2"
  profile = "ec2-nginx-lab"
}
```

The provider configuration tells Terraform which AWS region and profile to use.

## 4. main.tf – Discover the existing VPC

**File:** `main.tf`

```hcl
data "aws_vpc" "default" {
  default = true
}
```

This is a data source.

It discovers the existing default VPC in the configured AWS region. It does not create a new VPC.

The VPC ID becomes available through:

```hcl
data.aws_vpc.default.id
```

## 5. main.tf – Create the security group

**File:** `main.tf`

```hcl
resource "aws_security_group" "nginx" {
  name        = "terraform-ec2-nginx-sg"
  description = "Security group for the Terraform NGINX demo"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow public HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH from the configured trusted IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

### What these rules do

| Rule | Port | Source/destination | Purpose |
|---|---:|---|---|
| Ingress | 80 | `0.0.0.0/0` | Allow public HTTP access |
| Ingress | 22 | `var.ssh_allowed_cidr` | Allow SSH from the configured trusted IP range |
| Egress | All | `0.0.0.0/0` | Allow outbound IPv4 traffic |

The security group uses:

```hcl
vpc_id = data.aws_vpc.default.id
```

This connects the new security group to the existing VPC discovered by the data source.

## 6. variables.tf – Declare the SSH variable

**File:** `variables.tf`

```hcl
variable "ssh_allowed_cidr" {
  description = "Trusted IP CIDR allowed to SSH"
  type        = string
}
```

This declares an input variable. It does not contain the actual IP address.

The security group references this variable in `main.tf`:

```hcl
cidr_blocks = [var.ssh_allowed_cidr]
```

## 7. terraform.tfvars – Supply the actual SSH value

**File:** `terraform.tfvars`

The actual value is supplied here:

```hcl
ssh_allowed_cidr = "YOUR_CURRENT_PUBLIC_IP/32"
```

Replace the placeholder with your current public IPv4 address followed by `/32`.

For example, the value should represent one trusted IPv4 address, not the entire internet.

**Do not display your actual IP address in a public recording.**

Also, do not commit `terraform.tfvars` to a public GitHub repository if it contains environment-specific or sensitive values.

## 8. main.tf – Reuse the existing subnet

The EC2 resource in this project uses the existing subnet directly:

```hcl
subnet_id = "subnet-02ecdd68edfbf7326"
```

This is a literal subnet ID in the current configuration, not a Terraform input variable or a shell variable.

We are reusing the subnet selected during the manual networking discovery. Terraform is not creating a new subnet.

## 9. main.tf – Attach the security group to EC2

Inside the existing EC2 resource:

```hcl
resource "aws_instance" "nginx" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = "subnet-02ecdd68edfbf7326"
  vpc_security_group_ids      = [aws_security_group.nginx.id]
  key_name                    = "ec2-nginx-lab-key"
  associate_public_ip_address = true
}
```

The important networking references are:

```hcl
subnet_id = "subnet-02ecdd68edfbf7326"
```

This selects the existing subnet.

```hcl
vpc_security_group_ids = [aws_security_group.nginx.id]
```

This attaches the security group created by Terraform.

Terraform understands the dependency and creates the security group before creating the EC2 instance.

## 10. .gitignore – Protect local Terraform files

**File:** `.gitignore`

Ensure the relevant entries are present:

```gitignore
.terraform/
*.tfstate
*.tfstate.*
terraform.tfvars
crash.log
```

This helps prevent local Terraform state and environment-specific variable values from being committed.

Keep `.terraform.lock.hcl` in Git so the selected provider versions can be reproduced consistently.

## 11. Run Terraform commands

Run these commands from:

```bash
cd ~/projects/terraform-aws-ec2-nginx
```

Initialise Terraform:

```bash
terraform init
```

Format the configuration:

```bash
terraform fmt
```

Validate the configuration:

```bash
terraform validate
```

Inspect the existing state:

```bash
terraform state list
```

If unexpected resources are listed, stop and investigate before continuing.

Generate the execution plan:

```bash
terraform plan
```

Review the plan carefully.

For this project, the expected summary is:

```text
Plan: 2 to add, 0 to change, 0 to destroy.
```

The two new resources should be:

- `aws_security_group.nginx`
- `aws_instance.nginx`

The VPC and AMI should appear as data sources, not newly created resources.

The existing subnet should be reused.

Apply the configuration:

```bash
terraform apply
```

Review the plan and enter:

```text
yes
```

only if the proposed changes are correct.

## 12. Terraform networking summary

| Component | Terraform configuration | Action |
|---|---|---|
| Default VPC | `data.aws_vpc.default` | Discover existing |
| Subnet | `subnet_id` in EC2 resource | Reuse existing |
| Internet Gateway | Existing AWS networking | Reuse existing |
| Route table | Existing AWS networking | Reuse existing |
| Security group | `aws_security_group.nginx` | Create new |
| SSH CIDR | `var.ssh_allowed_cidr` | Read input value |
| EC2 attachment | `aws_security_group.nginx.id` | Attach new security group |

## 13. Important distinction

Manual deployment uses shell variables such as `VPC_ID`, `SUBNET_ID` and `SG_ID` to capture and reuse values returned by AWS CLI commands.

Terraform uses:

- Data sources to discover existing infrastructure.
- Resources to create and manage infrastructure.
- Input variables to accept configurable values.
- Resource references to connect infrastructure components.

The networking objective is the same in both approaches. The difference is how we define and manage the infrastructure.
