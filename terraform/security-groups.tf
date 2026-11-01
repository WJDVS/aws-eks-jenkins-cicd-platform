# EKS Cluster Security Group
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
