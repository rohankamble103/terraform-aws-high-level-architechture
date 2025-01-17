resource "aws_instance" "web" {
  ami = var.ami_id
  instance_type = var.my_instance_type
  subnet_id = var.subnet_id
  security_groups = [var.security_group_name]
  key_name = var.key_name
  user_data = <<-EOF
    #!/bin/bash
    echo "admin:YourSecurePassword123" | chpasswd
    sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
    systemctl restart sshd
  EOF
  tags = {
    Name = "web-instance"
  }
}

