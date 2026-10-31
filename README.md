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
- [ ] Day 4: NAT Gateways and private subnet route table configuration.

## 🏗️ Project Progress & Implementation Phases

### ✅ Day 3: Custom VPC & Core Networking Foundations
- **Custom VPC Provisioning:** Deployed `ekscicd-vpc` (`10.0.0.0/16`) with DNS hostnames and DNS resolution enabled.
- **Multi-AZ Subnetting:** Configured 4 subnets across two Availability Zones (`us-east-1a` and `us-east-1b`) split into 2 public and 2 private subnets.
- **Routing & Gateways:** Attached an Internet Gateway (`ekscicd-vpc-igw`), configured public and private route tables, and established an S3 Gateway Endpoint (`ekscicd-vpc-vpce-s3`).
- **Compute Verification:** Launched an Amazon Linux 2023 test VM (`ekscicd-test-vm`) in the public subnet, secured via an IP-restricted Security Group (`ekscicd-test-sg`) and SSH key pair (`ekscicd-key-pair`). End-to-end connectivity verified via WSL2 Ubuntu.
- **Visual Artifacts:** Architecture state and test connectivity captured and logged under `docs/screenshots/`.