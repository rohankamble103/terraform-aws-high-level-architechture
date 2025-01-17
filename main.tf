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

module "security_groups" {
  source = "./module/security_groups"
  vpc_id = module.vpc.vpc_id
  security_group_name = "my-sec-group"
  security_group_name_database = "secu-group-for-db"
}

module "ec2_instances" {
  source = "./module/ec2_instances"
  ami_id = "ami-0c55b159cbfafe1f0"
  my_instance_type = "t2.micro"
  subnet_id = module.vpc.public_subnet_id
  security_group_name = module.security_groups.web_security_group_id
  key_name = "my-key"
}

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

module "lb" {
  source = "./module/lb"
  vpc_id = module.vpc.vpc_id
  subnet_ids = [module.vpc.public_subnet_id]
  security_group_name = module.security_groups.web_security_group_id
}

