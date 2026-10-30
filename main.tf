# Find the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Use the existing default VPC
data "aws_vpc" "default" {
  default = true
}

# Create a dedicated security group for this project
resource "aws_security_group" "nginx" {
  name        = "terraform-ec2-nginx-sg"
  description = "Security group for the Terraform NGINX demo"
  vpc_id      = data.aws_vpc.default.id

  # Public HTTP access for the demo website
  ingress {
    description = "Allow public HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access restricted to the user's IP
  ingress {
    description = "Allow SSH from the configured trusted IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  # Allow outbound traffic for package installation and updates
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "terraform-ec2-nginx-sg"
    Project   = "terraform-aws-ec2-nginx"
    ManagedBy = "Terraform"
  }
}

# Launch the EC2 instance
resource "aws_instance" "nginx" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = "subnet-02ecdd68edfbf7326"
  vpc_security_group_ids      = [aws_security_group.nginx.id]
  key_name                    = "ec2-nginx-lab-key"
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y nginx
    systemctl enable nginx
    systemctl start nginx

    cat > /usr/share/nginx/html/index.html <<'HTML'
    <!DOCTYPE html>
    <html>
    <head>
      <title>Terraform NGINX Demo</title>
    </head>
    <body>
      <h1>NGINX is running!</h1>
      <p>Deployed using Terraform on AWS EC2.</p>
    </body>
    </html>
    HTML
  EOF

  tags = {
    Name      = "terraform-ec2-nginx"
    Project   = "terraform-aws-ec2-nginx"
    ManagedBy = "Terraform"
  }
}
