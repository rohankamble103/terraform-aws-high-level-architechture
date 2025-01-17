# Terraform Infrastructure Modules

Hi I am Rohan Kamble,
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
   git clone https://github.com/rohankamble103/terraform-aws-high-level-architechture.git
   cd terraform-aws-high-level-architechture
   ```

2. **Create a Main Configuration File**:
   
   Inside your project directory, create a `main.tf` file and include the modules you want to use. For example:
   ```hcl
   provider "aws" {
     region = "us-east-1"
   }
   
   module "vpc" {
     source = "./module/vpc"
     cidr_vpc = "10.0.0.0/16"
     vpc_name = "my-vpc"
     cidr_private_sub = "10.0.2.0/24"
     cidr_public_subnet = "10.0.1.0/24"
     availability_zone_private_sub = "us-east-1b"
     availability_zone_public_subnet = "us-east-1a"
     private_sub_name = "my-private-subnet"
     pub_sub_name = "my-pub-sub-name"
   }
   #Customise this vpc module according to you
   
   module "security_groups" {
     source = "./module/security_groups"
     vpc_id = module.vpc.vpc_id
     security_group_name = "my-sec-group"
     security_group_name_database = "secu-group-for-db"
   }
   #Customise this security group module according to you
   
   module "ec2_instances" {
     source = "./module/ec2_instances"
     ami_id = "ami-0c55b159cbfafe1f0"
     my_instance_type = "t2.micro"
     subnet_id = module.vpc.public_subnet_id
     security_group_name = module.security_groups.web_security_group_id
     key_name = "my-key"
   }
   #Customise this ec2_instance module according to you
   
   module "asg" {
     source = "./module/asg"
     ami_id = "ami-0c55b159cbfafe1f0"
     my_instance_type = "t2.micro"
     key_name = "my-key"
     subnet_ids = [module.vpc.public_subnet_id]
     security_group_name = "my-sec-group"
     asg_min = 1
     asg_max = 5
     user_data = <<-EOF
       #!/bin/bash
       echo "admin:YourSecurePassword123" | chpasswd
       sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
       sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
       systemctl restart sshd
     EOF
   }
   #Customise this asg module and user_data according to you
   
   module "db" {
     source = "./module/db"
     subnet_ids = module.vpc.private_subnet_id
     pub_acc_instance = false
     engine_db = "mysql"
     engine_db_version = "8.0"
     database_instance_class = "db.t2.micro"
     security_group_ids = module.security_groups.web_security_group_id
     db_name_rds = "my-db"
     memory_db_instance = 20
     mylti_az_value = true
     username_for_db = "root"
     password_for_db = "mypassword12"
   }
   #Customise this db module according to you
   
   module "lb" {
     source = "./module/lb"
     vpc_id = module.vpc.vpc_id
     subnet_ids = [module.vpc.public_subnet_id]
     security_group_name = module.security_groups.web_security_group_id
   }
   #Customise this lb module according to you
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
  source = "./module/vpc"
  cidr_vpc = "10.0.0.0/16"
  vpc_name = "my-vpc"
  cidr_private_sub = "10.0.2.0/24"
  cidr_public_subnet = "10.0.1.0/24"
  availability_zone_private_sub = "us-east-1b"
  availability_zone_public_subnet = "us-east-1a"
  private_sub_name = "my-private-subnet"
  pub_sub_name = "my-pub-sub-name"
}
```

### Deploy an EC2 Instance
```hcl
module "ec2_instances" {
  source = "./module/ec2_instances"
  ami_id = "ami-0c55b159cbfafe1f0"
  my_instance_type = "t2.micro"
  subnet_id = module.vpc.public_subnet_id
  security_group_name = module.security_groups.web_security_group_id
  key_name = "my-key"
}
```

### Add a Load Balancer
```hcl
module "lb" {
  source = "./module/lb"
  vpc_id = module.vpc.vpc_id
  subnet_ids = [module.vpc.public_subnet_id]
  security_group_name = module.security_groups.web_security_group_id
}
```

### Add a RDS db
```
module "db" {
  source = "./module/db"
  subnet_ids = module.vpc.private_subnet_id
  pub_acc_instance = false
  engine_db = "mysql"
  engine_db_version = "8.0"
  database_instance_class = "db.t2.micro"
  security_group_ids = module.security_groups.web_security_group_id
  db_name_rds = "my-db"
  memory_db_instance = 20
  mylti_az_value = true
  username_for_db = "root"
  password_for_db = "mypassword12"
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


