resource "aws_security_group" "my_security-group" {
  name        = var.security_group_name
  description = "Security group with ingress and egress rules"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "ingress_http" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.my_security-group.id
}

resource "aws_security_group_rule" "ingress_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.my_security-group.id
}

resource "aws_security_group_rule" "egress_specific" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["10.0.0.0/16"]
  security_group_id = aws_security_group.my_security-group.id
}

resource "aws_security_group" "database-sec-group" {
  name        = var.security_group_name_database
  description = "Security group for database"
  vpc_id      = var.vpc_id
}

