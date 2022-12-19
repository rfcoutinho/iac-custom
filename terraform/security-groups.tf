# Reference To avoid "cycle error" see this https://stackoverflow.com/questions/38246326/cycle-error-when-trying-to-create-aws-vpc-security-groups-using-terraform

resource "aws_security_group" "eks-cluster-sg" {
  name        = "eks-cluster-sg"
  description = "Principle of least privilege applied to the cluster"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = "eks-cluster-sg"
  }
}

resource "aws_security_group" "eks-nodes-sg" {
  name        = "eks-nodes-sg"
  description = "Principle of least privilege applied to the nodes"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = "eks-nodes-sg"
  }
}

resource "aws_security_group" "ec2" {
  name        = "ec2-sg"
  description = "Principle of least privilege applied to the nodes"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = "ec2-sg"
  }
}

# General security rules
resource "aws_security_group_rule" "allow-tls-to-web" {
  description       = "Allow TLS to web"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.eks-nodes-sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]

}


# Security Group rules attached to EKS Cluster security group

resource "aws_security_group_rule" "eks-nodes-tls-to-control-plane" {
  description              = "TLS from node security group"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-cluster-sg.id
  source_security_group_id = aws_security_group.eks-nodes-sg.id
}

resource "aws_security_group_rule" "eks-control-plane-tcp-to-nodes" {
  description              = "TCP communication to nodes"
  type                     = "egress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-cluster-sg.id
  source_security_group_id = aws_security_group.eks-nodes-sg.id
}

# Security Group rules attached to EKS Node security group

resource "aws_security_group_rule" "eks-nodes-tcp-from-contro-plane" {
  description              = "TCP communication from Control plane"
  type                     = "ingress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-nodes-sg.id
  source_security_group_id = aws_security_group.eks-cluster-sg.id
}

resource "aws_security_group_rule" "eks-nodes-tls-to-contro-plane" {
  description              = "TCP communication from Control plane"
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-nodes-sg.id
  source_security_group_id = aws_security_group.eks-cluster-sg.id
}

resource "aws_security_group_rule" "allow-ssh" {
  description       = "Allow ssh"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.ec2.id
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]

}

resource "aws_security_group_rule" "allow-web" {
  description       = "Allow Jenkins to Web"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  security_group_id = aws_security_group.ec2.id
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]

}

resource "aws_security_group_rule" "allow-jenkins" {
  description       = "Allow Jenkins to Web"
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = aws_security_group.ec2.id
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]

}