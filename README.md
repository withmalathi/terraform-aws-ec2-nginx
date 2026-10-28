# AWS EC2 + NGINX Deployment Using Terraform

A hands-on DevOps project to learn how to provision an AWS EC2 instance using Terraform and deploy an NGINX web server.

This project combines AWS infrastructure provisioning, Infrastructure as Code (IaC), Linux administration, networking, IAM permissions, and web server deployment in one beginner-friendly, step-by-step lab.

> **Current status:** Environment checks, AWS networking discovery, IAM permission preparation, and initial Terraform configuration are documented. EC2 provisioning and NGINX deployment are still in progress.

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Problem Statement](#2-problem-statement)
3. [Why We Need This Use Case](#3-why-we-need-this-use-case)
4. [When We Need This Use Case](#4-when-we-need-this-use-case)
5. [Tools and Technologies](#5-tools-and-technologies)
6. [Prerequisites](#6-prerequisites)
7. [Advantages and Disadvantages](#7-advantages-and-disadvantages)
8. [Project Structure](#8-project-structure)
9. [Step-by-Step Implementation](#9-step-by-step-implementation)
10. [Security Considerations](#10-security-considerations)
11. [Current Progress and Next Steps](#11-current-progress-and-next-steps)
12. [Conclusion](#12-conclusion)

## 1. Project Overview

The goal is to automate the provisioning of an AWS EC2 instance using Terraform and deploy NGINX to serve a basic web page.

Instead of creating all infrastructure manually through the AWS Console, Terraform will define the required resources in configuration files.

Before creating any cloud resources, the project checks the local environment, AWS credentials, region, existing networking resources, and IAM permissions. This helps identify potential problems before deployment.

### Planned workflow

1. Verify Terraform and AWS CLI installation.
2. Confirm the correct AWS profile and region.
3. Inspect existing VPC networking and EC2 resources.
4. Review security groups, key pairs, and instance type availability.
5. Check IAM permissions required for deployment.
6. Configure and validate Terraform.
7. Review the Terraform execution plan.
8. Provision the EC2 instance and dedicated security group.
9. Install and configure NGINX.
10. Verify the web page from a browser.
11. Document troubleshooting and clean up the lab resources.

## 2. Problem Statement

Deploying a web application on AWS requires creating and configuring cloud resources such as EC2 instances, networking, and security groups. Performing these tasks manually can take time and may lead to configuration errors.

This use case demonstrates how to prepare an AWS environment and use Terraform to automate EC2 provisioning, followed by deploying an NGINX web server.

The objective is to build a repeatable deployment process that beginners can understand, execute, verify, and document.

## 3. Why We Need This Use Case

- To understand how to launch and manage an AWS EC2 instance.
- To learn Infrastructure as Code using Terraform.
- To automate cloud resource provisioning.
- To understand AWS profiles, IAM permissions, and security groups.
- To practise Linux administration and web server deployment.
- To understand basic AWS networking and internet connectivity.
- To maintain infrastructure configuration using Git and GitHub.
- To learn how to review infrastructure changes before applying them.

## 4. When We Need This Use Case

This approach is useful:

- When hosting a basic web application on AWS.
- When creating development or testing environments.
- When learning AWS EC2 and Terraform.
- When replacing repetitive manual infrastructure setup with automation.
- When practising cloud deployment and basic DevOps workflows.
- When building a portfolio project to demonstrate practical cloud skills.

## 5. Tools and Technologies

| Tool | Purpose |
|---|---|
| AWS EC2 | Hosts the virtual machine |
| Terraform | Defines and provisions infrastructure |
| AWS CLI | Inspects AWS resources and verifies credentials |
| AWS IAM | Controls identity and permissions |
| Amazon VPC | Provides network isolation and connectivity |
| Security Groups | Control inbound and outbound traffic |
| Linux / Amazon Linux 2023 | Operating system for the EC2 instance |
| NGINX | Serves the web page |
| Git and GitHub | Version control and documentation |
| WSL Ubuntu | Local development environment |

## 6. Prerequisites

Before starting, ensure that you have:

- An AWS account.
- Terraform installed.
- AWS CLI installed and configured.
- A working AWS profile with the required permissions.
- WSL Ubuntu or another Linux terminal.
- Git installed and a GitHub account.
- Basic familiarity with Linux commands and AWS.

### Environment used

| Component | Configuration |
|---|---|
| Operating environment | WSL Ubuntu |
| Cloud provider | AWS |
| AWS region | `us-west-2` |
| AWS CLI profile | `ec2-nginx-lab` |
| Planned instance type | `t3.micro` |
| Planned operating system | Amazon Linux 2023 |
| Web server | NGINX |
| Infrastructure as Code | Terraform |

These are the intended lab settings. The EC2 instance and NGINX deployment have not yet been completed.

## 7. Advantages and Disadvantages

### Advantages

- **Automation:** Terraform provisions infrastructure from configuration files.
- **Consistency:** Configuration can be reused for repeatable deployments.
- **Version control:** Infrastructure changes can be tracked using Git.
- **Practical learning:** Combines AWS, Linux, networking, and Terraform.
- **Reviewable changes:** `terraform plan` previews proposed changes.
- **Resource management:** Terraform can manage and destroy resources created for the lab.

### Disadvantages

- **Learning curve:** Terraform syntax and AWS services require practice.
- **Permission issues:** Incorrect IAM permissions can prevent deployment.
- **Cost management:** Running AWS resources may incur charges.
- **State management:** Terraform state must be protected.
- **Security risks:** Incorrect security group rules can expose services.
- **Troubleshooting:** Networking, credentials, and configuration errors can cause deployment failures.

## 8. Project Structure

The repository is being developed in stages. The intended structure is:

```text
terraform-aws-ec2-nginx/
├── README.md
├── .gitignore
├── versions.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── user_data.sh
└── screenshots/
    ├── 1-1-current-directory.png
    ├── 1-2-check-whether-terraform-is-installed.png
    ├── 1-3-check-whether-aws-cli-is-installed.png
    ├── 1-4-check-which-aws-region-your-cli-currently-uses.png
    ├── 1-5-inspect-the-credential-source-without-revealing-the-secret-key.png
    ├── 1-6-check-which-named-profiles-exist.png
    ├── 1-7-test-each-aws-profile.png
    ├── 1-8-verify-the-working-aws-profile.png
    ├── 1-9-verify-the-region.png
    ├── 2-1-check-aws-permissions-before-creating-resources.png
    ├── 2-2-check-existing-subnets.png
    ├── 2-3-check-the-internet-gateway.png
    ├── 2-4-check-the-default-route-table.png
    ├── 2-5-check-ec2-permissions-no-output.png
    ├── 2-6-check-security-group-permissions.png
    ├── 2-7-inspect-the-existing-security-group-rules.png
    ├── 2-8-check-ec2-key-pairs.png
    ├── 2-9-verify-the-local-private-key.png
    ├── 2-10-verify-the-ec2-instance-type-is-available.png
    ├── 2-11-check-whether-you-can-inspect-your-own-iam-permissions.png
    ├── 2-12-retest-instance-type-discovery.png
    ├── 2-13-verify-the-ec2-deployment-permissions.png
    ├── 2-14-verify-ec2-instance-creation-permissions.png
    ├── 2-15-identify-the-remaining-permission-gaps.png
    ├── 2-16-update-the-deployment-policy-add-ec2-createtags.png
    ├── 2-17-verify-the-aws-credentials.png
    ├── 3-1-configure-terraform-to-use-the-correct-aws-profile.png
    └── 3-2-create-a-.gitignore-file.png
```

The Terraform files listed above represent the intended structure. Add each file as its implementation stage is completed. The screenshots listed above reflect the preparation steps documented so far.

## 9. Step-by-Step Implementation

### Phase 1: Environment Prerequisites

#### Step 1.1: Verify the working directory

The Terraform project is maintained separately from the manual EC2 + NGINX deployment project.

```bash
cd ~/projects/terraform-aws-ec2-nginx
pwd
```

Verify that the output points to the correct project directory.

Screenshot: `screenshots/1-1-current-directory.png`

#### Step 1.2: Verify Terraform installation

```bash
terraform version
```

Terraform is used to define and manage infrastructure through configuration files.

Screenshot: `screenshots/1-2-check-whether-terraform-is-installed.png`

#### Step 1.3: Verify AWS CLI installation

```bash
aws --version
```

The AWS CLI allows us to inspect AWS resources and verify the active identity.

Screenshot: `screenshots/1-3-check-whether-aws-cli-is-installed.png`

#### Step 1.4: Check the configured AWS region

```bash
aws configure get region --profile ec2-nginx-lab
```

The intended region is `us-west-2`, which corresponds to US West (Oregon).

Screenshot: `screenshots/1-4-check-which-aws-region-your-cli-currently-uses.png`

#### Step 1.5: Inspect credential configuration safely

Credential configuration was inspected without intentionally displaying the secret access key.

Never include access keys, secret keys, session tokens, or other credentials in public screenshots.

Screenshot: `screenshots/1-5-inspect-the-credential-source-without-revealing-the-secret-key.png`

#### Step 1.6: Check available AWS profiles

```bash
aws configure list-profiles
```

Named profiles help select the intended AWS credentials and configuration.

Screenshot: `screenshots/1-6-check-which-named-profiles-exist.png`

#### Step 1.7: Test AWS profiles

The default profile did not authenticate successfully during the initial checks. The named lab profile was tested instead.

Screenshot: `screenshots/1-7-test-each-aws-profile.png`

#### Step 1.8: Verify the working profile

```bash
aws sts get-caller-identity --profile ec2-nginx-lab
```

The `ec2-nginx-lab` profile successfully authenticated with AWS.

Screenshot: `screenshots/1-8-verify-the-working-aws-profile.png`

#### Step 1.9: Verify the region

```bash
aws configure get region --profile ec2-nginx-lab
```

Confirm that the configured region is `us-west-2`.

Screenshot: `screenshots/1-9-verify-the-region.png`

### Phase 2: AWS Environment Discovery

Before provisioning resources, inspect the existing AWS environment.

#### Step 2.1: Check permissions before creating resources

The goal is to identify permission gaps before attempting deployment.

Screenshot: `screenshots/2-1-check-aws-permissions-before-creating-resources.png`

#### Step 2.2: Inspect existing subnets

```bash
aws ec2 describe-subnets \
  --profile ec2-nginx-lab \
  --region us-west-2
```

Existing subnets were inspected to understand available networking options.

Screenshot: `screenshots/2-2-check-existing-subnets.png`

#### Step 2.3: Verify the internet gateway

```bash
aws ec2 describe-internet-gateways \
  --profile ec2-nginx-lab \
  --region us-west-2
```

The existing internet gateway and its attachment were inspected to understand the VPC's internet connectivity.

Screenshot: `screenshots/2-3-check-the-internet-gateway.png`

#### Step 2.4: Verify the route table

```bash
aws ec2 describe-route-tables \
  --profile ec2-nginx-lab \
  --region us-west-2
```

The route table was checked to understand the existing routes.

Screenshot: `screenshots/2-4-check-the-default-route-table.png`

#### Step 2.5: Check EC2 permissions

An initial permission check did not provide the expected output, so additional discovery and permission checks were performed.

Screenshot: `screenshots/2-5-check-ec2-permissions-no-output.png`

#### Step 2.6: Check security group permissions

Security group permissions were reviewed before creating or changing security rules.

Screenshot: `screenshots/2-6-check-security-group-permissions.png`

#### Step 2.7: Inspect existing security group rules

Existing inbound and outbound rules were inspected to avoid unintentionally changing shared networking configuration.

Screenshot: `screenshots/2-7-inspect-the-existing-security-group-rules.png`

#### Step 2.8: Check EC2 key pairs

```bash
aws ec2 describe-key-pairs \
  --profile ec2-nginx-lab \
  --region us-west-2
```

An existing key pair, `ec2-nginx-lab-key`, was found. The existing key was checked before deciding whether another key pair was necessary.

Screenshot: `screenshots/2-8-check-ec2-key-pairs.png`

#### Step 2.9: Verify the local private key

The existing local private key was checked.

Private keys must never be committed to GitHub or shared publicly.

Screenshot: `screenshots/2-9-verify-the-local-private-key.png`

#### Step 2.10: Verify instance type availability

The `t3.micro` instance type was checked for availability in the selected region and availability zones.

Screenshot: `screenshots/2-10-verify-the-ec2-instance-type-is-available.png`

#### Step 2.11: Check access to IAM information

An IAM inspection command was denied. This demonstrated that the lab user has limited permissions for some IAM operations.

Screenshot: `screenshots/2-11-check-whether-you-can-inspect-your-own-iam-permissions.png`

#### Step 2.12: Retest instance type discovery

Instance type discovery was retested after the required discovery permission was addressed.

Screenshot: `screenshots/2-12-retest-instance-type-discovery.png`

### Phase 3: IAM Permission Preparation

#### Step 3.1: Review EC2 deployment permissions

The deployment policy was reviewed for permissions required to create and manage the lab resources.

Screenshot: `screenshots/2-13-verify-the-ec2-deployment-permissions.png`

#### Step 3.2: Check EC2 instance creation permissions

The IAM Policy Simulator reported `Allowed` for the tested `ec2:RunInstances` action across the selected subnet, image, instance, network interface, and security group resource types.

This is a useful permission check, but it does not guarantee that every Terraform operation will succeed.

Screenshot: `screenshots/2-14-verify-ec2-instance-creation-permissions.png`

#### Step 3.3: Identify remaining permission gaps

The deployment policy was reviewed for additional permissions that may be needed for resource creation and tagging.

Screenshot: `screenshots/2-15-identify-the-remaining-permission-gaps.png`

#### Step 3.4: Update the deployment policy

The `EC2-NGINX-Lab-Deployment` policy was updated to include `ec2:CreateTags`.

The complete set of deployment permissions still needs to be validated against the finished Terraform configuration.

Screenshot: `screenshots/2-16-update-the-deployment-policy-add-ec2-createtags.png`

#### Step 3.5: Verify AWS credentials

```bash
aws sts get-caller-identity --profile ec2-nginx-lab
```

This read-only command successfully returned the active AWS identity, confirming that the intended profile can authenticate.

Screenshot: `screenshots/2-17-verify-the-aws-credentials.png`

### Phase 4: Terraform Configuration

#### Step 4.1: Configure the AWS provider

Create or verify `versions.tf` in the project directory:

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

This configuration specifies the Terraform version requirement, AWS provider version constraint, region, and intended AWS profile.

Screenshot: `screenshots/3-1-configure-terraform-to-use-the-correct-aws-profile.png`

#### Step 4.2: Create the `.gitignore` file

Create or verify `.gitignore`:

```gitignore
.terraform/
*.tfstate
*.tfstate.*
*.tfplan
*.tfvars
*.tfvars.json
.env
*.pem
*.key
crash.log
```

These rules help prevent generated Terraform data, local variable files, and private credentials from being committed.

Review the file before committing.

Screenshot: `screenshots/3-2-create-a-.gitignore-file.png`

#### Step 4.3: Initialize Terraform

After the required configuration files are ready, run:

```bash
terraform init
```

This initializes the working directory and downloads the required provider.

Verify that initialization completes successfully before proceeding.

#### Step 4.4: Validate the configuration

```bash
terraform validate
```

This checks whether the Terraform configuration is syntactically valid and internally consistent.

#### Step 4.5: Review the Terraform plan

```bash
terraform plan
```

Review the proposed changes before creating any AWS resources. Do not apply the configuration until the planned resources, security rules, and permissions have been checked.

### Phase 5: Provision the EC2 Instance

#### Step 5.1: Define the required resources

The planned Terraform configuration will define:

- An EC2 instance.
- A dedicated security group for the lab.
- The selected VPC and subnet.
- An appropriate Amazon Linux 2023 AMI.
- A startup script to install and configure NGINX.
- Outputs needed to verify access to the deployed web server.

The existing default VPC and shared security group should not be modified unnecessarily.

#### Step 5.2: Create the infrastructure

Once the configuration, IAM permissions, and plan have been verified, run:

```bash
terraform apply
```

Review the proposed changes and confirm only when the resources are correct.

**This step is planned and has not yet been completed.**

### Phase 6: Install and Configure NGINX

The NGINX installation will be performed using a startup script or commands appropriate for the selected Amazon Linux operating system.

The deployment should:

1. Install NGINX.
2. Enable the service.
3. Start the service.
4. Make a basic web page available.
5. Verify that the service is running.

For a manual service check after connecting to the instance:

```bash
sudo systemctl status nginx
```

This command should show NGINX as active once the installation and startup are successful.

**The NGINX deployment is planned and has not yet been completed.**

### Phase 7: Verify the Web Page

After the instance is running:

1. Retrieve the public IP address from the Terraform output or AWS Console.
2. Confirm that the instance has suitable network connectivity.
3. Verify that the security group permits inbound HTTP traffic on port 80.
4. Open the following address in a browser, replacing the placeholder with the actual public IP:

```text
http://<EC2-PUBLIC-IP>
```

5. Confirm that the NGINX welcome page or deployed web page appears.

A successful browser response will demonstrate that the instance, web server, and required network access are working together.

**The web page has not yet been verified.**

### Phase 8: Clean Up Resources

When the lab is complete, review the resources managed by this Terraform configuration.

Preview the destruction plan:

```bash
terraform plan -destroy
```

If the proposed changes are correct and the resources are no longer needed, run:

```bash
terraform destroy
```

Review the proposed destruction before confirming it.

Do not delete shared networking resources or resources outside the scope of this project.

## 10. Security Considerations

- Use the intended AWS profile explicitly.
- Never publish access keys, secret keys, session tokens, or private keys.
- Never commit private keys, Terraform state, or sensitive variable files to GitHub.
- Avoid changing the default VPC and shared security group unnecessarily.
- Use a dedicated security group for the lab.
- Allow only the inbound ports required for the demonstration.
- Restrict SSH access to a trusted source IP when SSH is needed; avoid opening it to the entire internet.
- Review IAM permissions and the Terraform plan before provisioning resources.
- Use the minimum permissions necessary for the deployment.
- Monitor AWS usage and costs.
- Destroy lab resources when they are no longer required.

## 11. Current Progress and Next Steps

### Completed so far

- Verified the local working directory.
- Checked Terraform and AWS CLI installation.
- Identified a working AWS named profile.
- Verified the intended AWS region.
- Inspected existing VPC networking, subnets, internet gateway, and route table.
- Inspected security groups and existing EC2 key pairs.
- Checked instance type availability.
- Reviewed EC2 deployment permissions.
- Updated the lab deployment policy to include `ec2:CreateTags`.
- Verified AWS identity using STS.
- Began preparing the Terraform provider configuration and `.gitignore`.

### Remaining steps

- Verify `versions.tf` and `.gitignore`.
- Complete the Terraform resource configuration.
- Initialize and validate Terraform.
- Confirm all required AWS permissions.
- Review the Terraform execution plan.
- Provision the EC2 instance and dedicated security group.
- Install and verify NGINX.
- Test the web page from a browser.
- Capture deployment screenshots and document troubleshooting.
- Review and execute cleanup when the lab is complete.

> **Project status:** This project is still in the preparation and configuration stage. EC2 provisioning, NGINX deployment, and browser verification will be documented after they have been successfully completed.

## 12. Conclusion

This hands-on use case brings together AWS EC2, Terraform, IAM, networking, Linux, and NGINX in one practical DevOps project.

The project begins with environment and permission checks before moving to infrastructure provisioning. Each stage will be documented with commands, verification steps, and screenshots so that beginners can follow the process and understand not only what to do, but also why each step is necessary.

The final goal is a repeatable Terraform deployment of an AWS EC2 instance serving a web page through NGINX, together with a documented verification and cleanup process.

---

*Built as a hands-on learning project to practise AWS, Terraform, Linux, infrastructure automation, security, and DevOps documentation.*