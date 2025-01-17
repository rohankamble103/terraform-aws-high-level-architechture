resource "aws_launch_configuration" "as_config" {
  name_prefix = "terraform-ls"
  image_id = var.ami_id
  instance_type = var.my_instance_type
  security_groups = [var.security_group_name]
  key_name = var.key_name
  user_data = <<-EOF
    #!/bin/bash
    echo "admin:YourSecurePassword123" | chpasswd
    sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
    systemctl restart sshd
  EOF
}

resource "aws_autoscaling_group" "autoscale_myapp" {
  name = "autoscaling_group_my"
  launch_configuration = aws_launch_configuration.as_config.name
  min_size = var.asg_min
  max_size = var.asg_max
  vpc_zone_identifier = var.subnet_ids

  health_check_type = "EC2"
  health_check_grace_period = 300
  force_delete = true

  tag {
    key = "Name"
    value = "web-instance"
    propagate_at_launch = true
  }
}

