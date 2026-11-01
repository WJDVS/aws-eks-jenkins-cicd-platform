# EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = "ekscicd-eks-cluster"
  role_arn = aws_iam_role.cluster_role.arn
  version  = "1.37"

  vpc_config {
    subnet_ids = [
      aws_subnet.public_1.id,
      aws_subnet.public_2.id,
      aws_subnet.private_1.id,
      aws_subnet.private_2.id
    ]
    security_group_ids      = [aws_security_group.cluster_sg.id]
    endpoint_public_access  = true
    endpoint_private_access = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_amazon_eks_cluster_policy
  ]

  tags = {
    Name = "ekscicd-eks-cluster"
  }
}

# EKS Managed Node Group
resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "ekscicd-eks-nodegroup"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"]

  depends_on = [
    aws_iam_role_policy_attachment.node_amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.node_amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.node_amazon_ec2_container_registry_read_only
  ]

  tags = {
    Name = "ekscicd-eks-nodegroup"
  }
}
