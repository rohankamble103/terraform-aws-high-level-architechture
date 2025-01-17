resource "aws_db_subnet_group" "my_db_subnet_group" {
  name        = "my-db-subnet-group"
  description = "Subnet group for database"
  subnet_ids  = [var.subnet_ids]
}

resource "aws_db_instance" "my-db-instance" {
  allocated_storage   = var.memory_db_instance
  db_name             = var.db_name_rds
  engine              = var.engine_db
  engine_version      = var.engine_db_version
  instance_class      = var.database_instance_class
  username            = var.username_for_db
  password            = var.password_for_db
  vpc_security_group_ids = [var.security_group_ids]
  db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name
  multi_az = var.mylti_az_value
  publicly_accessible = var.pub_acc_instance
}

