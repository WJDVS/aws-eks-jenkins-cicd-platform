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
- [ ] Day 3: AWS networking & compute built by hand in the console.