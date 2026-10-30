output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.nginx.id
}

output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.nginx.public_ip
}

output "nginx_website_url" {
  description = "URL of the NGINX website"
  value       = "http://${aws_instance.nginx.public_ip}"
}
