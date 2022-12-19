
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"


  name = "jenkins"

  ami                    = "ami-0b93ce03dcbcb10f6"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.jenkins_key.key_name
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.ec2.id]
  subnet_id              = module.vpc.public_subnets.0


  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "Jenkins"
  }

  user_data_base64 = base64encode(local.jenkins-userdata)
}

locals {
  jenkins-userdata = <<EOF
  #!/bin/env bash

  sudo apt-get update -y

  EOF
}

resource "aws_key_pair" "jenkins_key" {
  key_name   = "jenkins.pub"
  public_key = file("./artifacts/ec2/jenkins.pub")
}
