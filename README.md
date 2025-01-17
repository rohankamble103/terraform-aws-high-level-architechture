# Terraform Infrastructure Modules

Welcome to the Terraform Infrastructure Modules project! This repository provides a set of reusable and customizable Terraform modules to help you quickly and efficiently deploy and manage cloud infrastructure. By using this project, you can create a variety of AWS resources with minimal configuration.

## Features

This project enables the creation of the following resources:

- **Auto Scaling Groups (ASG)**: Automatically scale your EC2 instances based on demand.
- **Databases (DB)**: Provision database instances with security and reliability.
- **EC2 Instances**: Launch and manage individual virtual machines in AWS.
- **Load Balancers (LB)**: Distribute incoming application traffic across multiple targets, such as EC2 instances.
- **Security Groups**: Manage inbound and outbound rules to control traffic to your resources.
- **VPC (Virtual Private Cloud)**: Set up a secure and isolated network environment with public and private subnets.

## Prerequisites

Before using these modules, ensure you have the following:

1. **Terraform** installed on your local machine. [Download Terraform](https://www.terraform.io/downloads)
2. **AWS CLI** configured with appropriate permissions. [Configure AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
3. **Access and Secret Keys** for your AWS account.

## Getting Started

To start using this module, follow these steps:

1. **Clone the Repository**:
   ```bash
   git clone <repository-url>
   cd <repository-folder>
   ```

2. **Create a Main Configuration File**:
   
   Inside your project directory, create a `main.tf` file and include the modules you want to use. For example:
   ```hcl
   module "vpc" {
     source = "./modules/vpc"
     # Add required variables for VPC module
   }

   module "security_groups" {
     source = "./modules/security_groups"
     # Add required variables for Security Groups
   }

   module "lb" {
     source = "./modules/lb"
     # Add required variables for Load Balancer
   }
   ```

3. **Initialize Terraform**:
   ```bash
   terraform init
   ```

4. **Plan Infrastructure**:
   ```bash
   terraform plan
   ```
   Review the execution plan to ensure everything is as expected.

5. **Apply Infrastructure**:
   ```bash
   terraform apply
   ```
   Confirm the changes to create your infrastructure.

## Example Usage

### Create a VPC with Public and Private Subnets
```hcl
module "vpc" {
  source        = "./modules/vpc"
  cidr_block    = "10.0.0.0/16"
  public_subnet = {
    cidr_block = "10.0.1.0/24"
    az         = "us-east-1a"
  }
  private_subnet = {
    cidr_block = "10.0.2.0/24"
    az         = "us-east-1b"
  }
}
```

### Deploy an EC2 Instance
```hcl
module "ec2" {
  source        = "./modules/ec2_instances"
  instance_type = "t2.micro"
  ami_id        = "ami-12345678"
  key_name      = "my-key-pair"
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_id
}
```

### Add a Load Balancer
```hcl
module "lb" {
  source                  = "./modules/lb"
  vpc_id                  = module.vpc.vpc_id
  public_subnet_ids       = module.vpc.public_subnet_ids
  target_group_name       = "app-target-group"
  load_balancer_name      = "my-load-balancer"
}
```

## Modules Included

### VPC Module
- Creates a custom VPC with public and private subnets.
- Supports multiple availability zones.

### Security Groups Module
- Define ingress and egress rules for various use cases.
- Predefined rules for HTTP, HTTPS, and SSH access.

### Load Balancer Module
- Provisions an Application Load Balancer (ALB).
- Automatically registers EC2 instances in the target group.

### EC2 Module
- Launches instances with specified AMI, instance type, and key pair.
- Attaches instances to security groups and subnets.

### Database Module
- Creates a managed database instance with security group configurations.
- Supports multiple database engines like MySQL, PostgreSQL, etc.

### Auto Scaling Group Module
- Automatically adjusts the number of instances based on load.
- Configurable scaling policies and health checks.

## Inputs

Each module accepts various input variables for customization. Refer to the documentation in each module directory for details.

## Outputs

The modules provide outputs such as resource IDs, DNS names, and other useful information. Review the `outputs.tf` file in each module for details.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more information.

---

Feel free to contribute to this project or raise issues for any enhancements or bugs.


