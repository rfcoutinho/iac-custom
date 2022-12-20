
resource "aws_instance" "jenkins" {

  ami                    = "ami-035469b606478d63d"
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


  connection {
    type        = "ssh"
    user        = "ubuntu"
    password    = ""
    private_key = file("../artifacts/ec2/jenkins")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "../artifacts/scripts/install-jenkins.sh"
    destination = "/tmp/install-jenkins.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-jenkins.sh",
      "/tmp/install-jenkins.sh",
    ]
  }
}


resource "aws_key_pair" "jenkins_key" {
  key_name   = "jenkins.pub"
  public_key = file("../artifacts/ec2/jenkins.pub")
}

resource "aws_iam_policy_attachment" "attach" {
  name       = "jenkins-attach"
  roles      = ["${aws_iam_role.role.name}"]
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "profile" {
  name = "jenkins-profile"
  role = aws_iam_role.role.name
}

