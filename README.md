# Automated CI/CD on AWS EKS: GitHub, Jenkins, ECR, and EKS Built with Terraform and Ansible

## Overview
This repository contains a complete, production-grade automated CI/CD pipeline and cloud infrastructure built for a Node.js web application. 

- **Infrastructure as Code:** Provisioned using Terraform with S3 native state locking.
- **Configuration Management:** Jenkins server configured via Ansible.
- **Containerization & Registry:** Docker images tagged by Git commit SHA stored in Amazon ECR.
- **Orchestration:** Deployed to Amazon EKS running across private subnets behind an AWS Application Load Balancer.

## Current Status
- [x] Day 1: VS Code, Git & GitHub setup and directory structure initialized.
- [x] Day 2: Linux & AWS foundations (IAM, AWS CLI, CloudWatch billing alarms, SSH keys).
- [x] Day 3: AWS networking & compute built by hand in the console.
- [x] Day 4: NAT Gateways, private subnet route table configuration, and egress validation.

## 🏗️ Project Progress & Implementation Phases

### ✅ Day 3: Custom VPC & Core Networking Foundations
- **Custom VPC Provisioning:** Deployed `ekscicd-vpc` (`10.0.0.0/16`) with DNS hostnames and DNS resolution enabled.
- **Multi-AZ Subnetting:** Configured 4 subnets across two Availability Zones (`us-east-1a` and `us-east-1b`) split into 2 public and 2 private subnets.
- **Routing & Gateways:** Attached an Internet Gateway (`ekscicd-vpc-igw`), configured public and private route tables, and established an S3 Gateway Endpoint (`ekscicd-vpc-vpce-s3`).
- **Compute Verification:** Launched an Amazon Linux 2023 test VM (`ekscicd-test-vm`) in the public subnet, secured via an IP-restricted Security Group (`ekscicd-test-sg`) and SSH key pair (`ekscicd-key-pair`). End-to-end connectivity verified via WSL2 Ubuntu.
- **Visual Artifacts:** Architecture state and test connectivity captured and logged under `docs/screenshots/`.

### ✅ Day 4: NAT Gateways, Private Subnet Egress & Connectivity Validation
- **NAT Gateway Provisioning:** Deployed `ekscicd-nat-gw` in `ekscicd-vpc-subnet-public1-us-east-1a` with a dedicated Elastic IP (`52.87.219.51`).
- **Private Routing:** Configured private route tables in both Availability Zones with default routes (`0.0.0.0/0`) targeted at `ekscicd-nat-gw` for outbound traffic translation.
- **Private Compute & Security:** Launched `ekscicd-test-private-vm` (`10.0.135.206`) in Private Subnet 1 (`us-east-1a`) with no public IP. Enforced strict security group (`ekscicd-private-test-sg`) allowing SSH access (Port 22) exclusively from the public jump host's security group (`sg-0fbcd3fae17ba3277`).
- **Multi-Hop Access Validation:** Established a secure two-hop access pattern from local WSL2 terminal through the public jump host (`10.0.11.236`) into the private instance using SSH agent forwarding (`-A`).
- **Egress Verification:** Validated outbound connectivity from the private instance, achieving 0% packet loss on ICMP pings to `8.8.8.8` and a successful `HTTP/2 200` response from `aws.amazon.com` via the NAT Gateway.
- **Visual Artifacts:** Terminal output and egress validation captured at `docs/screenshots/04-private-instance-ping.png`.