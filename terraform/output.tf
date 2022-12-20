output "jenkins_ip" {
  description = "Jenkins Public IP Address"
  value       = aws_instance.jenkins.public_ip
}