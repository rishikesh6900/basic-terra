# Terraform AWS EC2 Portfolio Deployment

Provision and configure an AWS EC2 instance using **Terraform**, with automated web server installation and portfolio deployment through EC2 user data.

This project demonstrates the fundamentals of Infrastructure as Code (IaC), AWS resource provisioning, security group configuration, and automated web server setup using Terraform and Ubuntu.

## Project Overview

The objective of this project is to deploy a simple portfolio website on AWS without manually creating infrastructure through the AWS Management Console.

Terraform provisions the required AWS resources, while an initialization script installs and configures Nginx on the EC2 instance. Once the instance is initialized, the portfolio website becomes accessible through its public IP address.

### Key Features

- Infrastructure provisioning using Terraform.
- AWS EC2 instance deployment.
- Automated Nginx installation using EC2 user data.
- Security group configuration for HTTP traffic.
- Automated creation of website content.
- Terraform state management and resource tracking.
- Infrastructure cleanup using Terraform.

## Tech Stack

| Technology | Purpose |
|---|---|
| Terraform | Infrastructure provisioning and management |
| AWS EC2 | Virtual machine hosting the website |
| AWS VPC | Network infrastructure for the EC2 instance |
| AWS Security Groups | Network traffic control |
| Nginx | Web server |
| Bash | Instance initialization and automation |
| Ubuntu 22.04 | Local development environment |
| AWS CLI | AWS authentication and identity verification |

## Architecture

The deployment follows this workflow:

```text
Ubuntu 22.04 Virtual Machine
            |
            v
          AWS CLI
            |
            v
         Terraform
            |
            v
       AWS Provider
            |
            v
     AWS Infrastructure
            |
            +----------------------+
            |                      |
            v                      v
    EC2 Security Group        EC2 Instance
            |                      |
            |                      v
            |                EC2 User Data
            |                      |
            |                      v
            |                Install Nginx
            |                      |
            |                      v
            |                Create index.html
            |                      |
            +----------------------+
                       |
                       v
                HTTP Port 80
                       |
                       v
              Portfolio Website
```

**Deployment flow:**

1. Configure AWS CLI credentials in the Ubuntu virtual machine.
2. Initialize Terraform and download the AWS provider.
3. Generate an execution plan to preview infrastructure changes.
4. Provision the security group and EC2 instance.
5. Execute the EC2 user-data script during instance initialization.
6. Install and start Nginx.
7. Serve the portfolio website over HTTP.

## AWS Resources

The following resources were provisioned or configured by Terraform.

| Resource | Configuration |
|---|---|
| EC2 instance | `t3.micro` |
| AWS Region | `ap-southeast-2` (Asia Pacific — Sydney) |
| Operating system | Ubuntu-compatible Linux AMI |
| Web server | Nginx |
| Security group | `Basic-Security Group` |
| Inbound rule | TCP port 80 |
| Inbound source | `0.0.0.0/0` |
| Outbound traffic | All protocols to `0.0.0.0/0` |
| Instance tag | `Name = basic-terra` |
| Website | Static HTML portfolio |

The instance AMI is specified in `main.tf`. Confirm that the selected AMI is available and appropriate for your target region before recreating the deployment.

**Note:** The instance type's Free Tier eligibility depends on the account's applicable AWS Free Tier terms and the current regional offering. Do not assume that `t3.micro` is free for your account.

## Project Structure

The project directory is organized around Terraform configuration and the instance initialization script.

```text
basic-terra/
├── main.tf
├── provider.tf
├── userdata.sh
├── .terraform.lock.hcl
├── .terraform/
├── terraform.tfstate
└── README.md
```

### File Descriptions

| File | Description |
|---|---|
| `provider.tf` | Configures the AWS provider and deployment region. |
| `main.tf` | Defines the EC2 instance, security group, ingress and egress rules, and output values. |
| `userdata.sh` | Contains the Bash commands and HTML content used to initialize the web server. |
| `.terraform.lock.hcl` | Records the selected Terraform provider versions and checksums. |
| `.terraform/` | Contains downloaded provider plugins and Terraform initialization data. |
| `terraform.tfstate` | Tracks the infrastructure managed by Terraform. |
| `README.md` | Documents the project and deployment process. |

The exact structure may vary depending on how the configuration files are organized. The `.terraform/` directory and state file are generated during Terraform operations.

**Important:** Do not commit AWS credentials, private keys, or local Terraform state files to a public repository. For this learning project, keep the state file local unless you deliberately configure secure remote state storage.

## Prerequisites

Before deploying the project, ensure that you have:

- An AWS account with permission to manage the required EC2 and security group resources.
- An Ubuntu 22.04 environment, either a physical machine or a virtual machine.
- AWS CLI installed and configured.
- Terraform installed.
- Internet connectivity.
- An available EC2 key pair if you intend to connect to the instance using SSH.

### 1. Verify AWS CLI

Check whether the AWS CLI is installed:

```bash
aws --version
```

Configure your AWS credentials:

```bash
aws configure
```

Provide the following information when prompted:

```text
AWS Access Key ID
AWS Secret Access Key
Default region name: ap-southeast-2
Default output format: json
```

Verify the identity associated with the configured credentials:

```bash
aws sts get-caller-identity
```

This command returns the AWS account ID, IAM user or role ARN, and caller identity.

**Security note:** Never upload access keys or secret access keys to GitHub. For longer-term projects, prefer IAM roles or another supported short-lived credential mechanism where practical.

### 2. Install Terraform

On Ubuntu, install the required packages:

```bash
sudo apt-get update
sudo apt-get install -y gnupg software-properties-common wget
```

Add HashiCorp's official signing key:

```bash
wget -O- https://apt.releases.hashicorp.com/gpg \
  | gpg --dearmor \
  | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg \
  > /dev/null
```

Add the HashiCorp package repository:

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" \
  | sudo tee /etc/apt/sources.list.d/hashicorp.list
```

Install Terraform:

```bash
sudo apt-get update
sudo apt-get install -y terraform
```

Verify the installation:

```bash
terraform version
```

### 3. Initialize the Project

Navigate to the project directory:

```bash
mkdir -p basic-terra
cd basic-terra
```

Create or copy the Terraform configuration files into this directory.

Initialize Terraform:

```bash
terraform init
```

This downloads the required provider plugins and prepares the working directory.

## Deployment Guide

### Step 1: Review the Configuration

Inspect the Terraform files:

```bash
cat provider.tf
cat main.tf
cat userdata.sh
```

Verify the following:

- The AWS provider is configured for `ap-southeast-2`.
- The selected AMI is valid in the target region.
- The EC2 instance type is available for your account.
- The security group permits the intended HTTP traffic.
- The user-data script uses commands compatible with the selected operating system.
- The required IAM permissions are available.

### Step 2: Initialize Terraform

```bash
terraform init
```

Expected result:

```text
Terraform has been successfully initialized!
```

### Step 3: Validate the Configuration

```bash
terraform fmt -recursive
terraform validate
```

`terraform fmt` formats the configuration files, while `terraform validate` checks their syntax and internal consistency.

### Step 4: Generate an Execution Plan

```bash
terraform plan
```

Terraform compares the desired configuration with its recorded state and the available infrastructure information.

The original deployment plan showed:

```text
Plan: 4 to add, 0 to change, 0 to destroy.
```

This included the EC2 instance, security group, and separate ingress and egress rule resources.

Review the plan before proceeding. A successful plan does not guarantee that AWS will accept every requested operation.

### Step 5: Deploy the Infrastructure

Apply the configuration:

```bash
terraform apply
```

Review the proposed changes and enter `yes` when prompted.

For a non-interactive deployment, you can use:

```bash
terraform apply -auto-approve
```

**Use `-auto-approve` only when you are comfortable with the proposed changes.**

The EC2 instance and associated security group resources will be created according to the Terraform configuration.

### Step 6: Retrieve the Public IP Address

The configuration defines an output named `instance_public_ip`.

Retrieve it with:

```bash
terraform output instance_public_ip
```

Alternatively:

```bash
terraform output -raw instance_public_ip
```

The original successful deployment returned:

```text
54.252.211.184
```

This address is specific to the recorded deployment. Your public IP may be different when you recreate the infrastructure.

### Step 7: Access the Website

Open a browser and navigate to:

```text
http://<EC2_PUBLIC_IP>
```

Replace `<EC2_PUBLIC_IP>` with the address returned by Terraform.

For example, during the original deployment:

```text
http://54.252.211.184
```

If initialization has completed successfully, Nginx should serve the generated portfolio page.

The user-data script creates the website at:

```text
/var/www/html/index.html
```

The page includes a heading, a short description, and external links.

## How EC2 User Data Works

EC2 user data allows commands or scripts to run during instance initialization.

In this project, Terraform supplies a Bash initialization script to the EC2 instance.

The script performs the following operations:

1. Updates the package index.
2. Installs Nginx.
3. Enables Nginx to start automatically when the system boots.
4. Starts the Nginx service.
5. Writes the portfolio HTML into Nginx's default web root.

The resulting website is served by Nginx over HTTP.

### Important Implementation Detail

The initialization script shown in the Terraform plan uses commands such as:

```bash
apt update -y
apt install nginx -y

systemctl enable nginx
systemctl start nginx
```

These commands are appropriate for Ubuntu-based instances.

If you change the AMI to Amazon Linux or another distribution, adapt the package installation commands and web server configuration accordingly.

User data normally runs during the instance's initial launch. Editing the local script does not automatically rerun it on an already-running instance. A change to user data alone also does not necessarily replace an existing instance.

For repeatable deployments, consider making the initialization process more robust by adding logging, error handling, and explicit service health checks.

## Terraform Commands Reference

| Command | Purpose |
|---|---|
| `terraform init` | Initializes the working directory and installs providers. |
| `terraform fmt` | Formats Terraform configuration files. |
| `terraform validate` | Validates configuration syntax and consistency. |
| `terraform plan` | Previews proposed infrastructure changes. |
| `terraform apply` | Creates or updates infrastructure. |
| `terraform output` | Displays configured output values. |
| `terraform show` | Displays the current state or a saved plan. |
| `terraform state list` | Lists resources tracked in Terraform state. |
| `terraform refresh` | Refreshes state information through a state-refresh operation. |
| `terraform destroy` | Removes resources managed by the configuration. |

For routine work, prefer `terraform plan` followed by `terraform apply`. Avoid using legacy state-management commands as a substitute for reviewing the actual infrastructure changes.

## Troubleshooting

### 1. EC2 Instance Type Not Eligible for Free Tier

**Error encountered:**

```text
InvalidParameterCombination:
The specified instance type is not eligible for Free Tier.
```

The initial configuration used `t2.micro`. AWS rejected the request because the instance type was not eligible under the applicable account or Free Tier conditions.

**Resolution:**

Changed the instance type in `main.tf` to:

```hcl
instance_type = "t3.micro"
```

Then reran:

```bash
terraform plan
terraform apply
```

The instance was successfully created.

**Lesson:** Instance availability and Free Tier eligibility are separate considerations. Check the current AWS account terms, regional availability, and applicable instance-type restrictions before deploying.

### 2. Terraform Cannot Find AWS Credentials

**Typical error:**

```text
Error: configuring Terraform AWS Provider:
no valid credential sources found
```

Terraform needs valid AWS credentials to authenticate API requests.

**Resolution:**

Verify the AWS CLI identity:

```bash
aws sts get-caller-identity
```

If necessary, configure credentials:

```bash
aws configure
```

Then retry:

```bash
terraform plan
```

Do not place access keys directly in Terraform configuration files.

### 3. Website Does Not Load

If the EC2 instance exists but the website is inaccessible, check the following:

**Security group**

Confirm that inbound TCP port 80 is allowed from your intended client IP range.

**Instance status**

Verify that the EC2 instance is running and has a public IP address.

**Nginx service**

If you can connect to the instance through SSH:

```bash
sudo systemctl status nginx
```

Start the service if necessary:

```bash
sudo systemctl start nginx
```

**User-data logs**

On Ubuntu, inspect the initialization log:

```bash
sudo tail -n 100 /var/log/cloud-init-output.log
```

**HTTP response**

From the Ubuntu development environment, run:

```bash
curl -I http://<EC2_PUBLIC_IP>
```

Replace the placeholder with the actual public IP.

A successful HTTP response indicates that the server is responding, although you should also inspect the page content to verify that the intended portfolio was deployed.

### 4. Changes to the Script Are Not Reflected

Updating `userdata.sh` locally does not modify a website already running on EC2.

To update the website manually, connect to the instance and modify the web root, or introduce a dedicated deployment mechanism.

For an improved implementation, consider separating infrastructure provisioning from application deployment.

## Security Considerations

This is a learning project, not a production-hardened web deployment.

Before using a similar configuration in a real environment:

- Restrict SSH access to trusted IP addresses if SSH is enabled.
- Avoid exposing unnecessary inbound ports.
- Store credentials outside the repository.
- Avoid committing Terraform state files containing potentially sensitive infrastructure information.
- Consider remote state storage with encryption, access controls, and state locking where supported.
- Use least-privilege IAM policies.
- Consider HTTPS through a suitable certificate and web server or load balancer configuration.
- Review EC2 user-data handling before placing sensitive information in scripts.
- Monitor AWS usage and costs.

The current security group allows HTTP traffic from `0.0.0.0/0`, meaning the website can be accessed from the public internet if the rest of the network configuration permits it.

## Cleanup

AWS resources can continue generating charges after deployment.

When you finish experimenting, navigate to the project directory and run:

```bash
terraform destroy
```

Review the proposed deletions and confirm when prompted.

For a non-interactive cleanup:

```bash
terraform destroy -auto-approve
```

Verify the cleanup through the Terraform output and AWS console if needed.

**Important:** Terraform can only reliably destroy resources tracked by the relevant state and configuration. Do not delete the state file before cleaning up the infrastructure it manages.

## Future Improvements

Potential extensions to this project include:

- Provisioning a custom VPC with public and private subnets.
- Creating reusable Terraform modules.
- Using variables and separate environment-specific configuration files.
- Adding an Elastic IP when a stable public address is required.
- Configuring HTTPS with a domain name and TLS certificate.
- Automating deployment through a CI/CD pipeline.
- Using Ansible for configuration management.
- Adding CloudWatch monitoring and alarms.
- Introducing remote Terraform state storage.
- Implementing separate development and production environments.
- Deploying a containerized application instead of a static HTML page.

## Key Learnings

Through this project, I practiced:

- Configuring Terraform on an Ubuntu virtual machine.
- Connecting Terraform to AWS using the AWS provider.
- Authenticating AWS API requests using the AWS CLI credential chain.
- Defining EC2 instances and security group rules as code.
- Using Terraform initialization, planning, application, and state tracking.
- Automating server setup with EC2 user data.
- Installing and configuring Nginx for HTTP hosting.
- Troubleshooting AWS instance-type restrictions.
- Retrieving infrastructure outputs without relying on the AWS console.

## Conclusion

This project demonstrates a basic Infrastructure as Code workflow in which Terraform provisions AWS infrastructure and EC2 user data automates web server initialization.

It provides a foundation for more advanced cloud and DevOps projects involving reusable infrastructure modules, configuration management, CI/CD pipelines, monitoring, and multi-environment deployments.

---

**Author:** Rishikesh Nate

**Project:** Terraform AWS EC2 Portfolio Deployment

**Environment:** Ubuntu 22.04 VM + AWS CLI + Terraform
