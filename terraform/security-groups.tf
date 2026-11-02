# ==========================================
# EKS Cluster Security Group
# ==========================================
resource "aws_security_group" "cluster_sg" {
  name        = "ekscicd-eks-cluster-sg"
  description = "Cluster communication security group for EKS control plane"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ekscicd-eks-cluster-sg"
  }
}

# ==========================================
# Jenkins Security Group
# ==========================================
resource "aws_security_group" "jenkins_sg" {
  name        = "ekscicd-jenkins-sg"
  description = "Security group for Jenkins CI/CD server"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow SSH from Management"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Jenkins Web UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ekscicd-jenkins-sg"
  }
}