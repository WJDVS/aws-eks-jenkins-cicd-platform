# ==========================================
# Jenkins EC2 Compute Instance
# ==========================================
resource "aws_instance" "jenkins" {
  ami                    = "ami-04a81a99f5ec58529" # Ubuntu 24.04 LTS / latest stable AMI in us-east-1
  instance_type          = "t3.medium"
  subnet_id              = aws_subnet.public_1.id
  key_name               = "ekscicd-key-pair"
  iam_instance_profile   = aws_iam_instance_profile.jenkins_profile.name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  tags = {
    Name = "ekscicd-jenkins-server"
  }
}