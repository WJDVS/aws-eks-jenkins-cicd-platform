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
- [x] Day 5: Manual EKS infrastructure setup, IAM roles, control plane, and managed node group deployment.
- [x] Day 6: Terraform infrastructure as code, remote S3 state backend, clean-slate conflict teardown, automated EKS cluster deployment, and GitHub synchronization.

---

## 📐 Architecture Overview

The following diagram outlines the system architecture for the EKS CI/CD pipeline, detailing resources provisioned via Terraform (Day 6) and planned components for subsequent days:

![Architecture Diagram](docs/screenshots/ekscicd-architecture.png)

---

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

### ✅ Day 5: Manual EKS Infrastructure & Cluster Setup
- **Core Provisioning:** Completed the manual provisioning of core AWS EKS infrastructure via the AWS CLI to establish foundational networking and control plane security.
- **Provisioned Resources:**
  - **VPC:** `ekscicd-vpc` (`10.0.0.0/16`) with public and private subnets across two Availability Zones.
  - **IAM Roles:** 
    - `ekscicd-eks-cluster-role` with `AmazonEKSClusterPolicy`.
    - `ekscicd-eks-nodegroup-role` with worker node policies.
  - **Security Group:** `ekscicd-eks-cluster-sg` (`sg-061c2e4640ef8bdd6`).
  - **EKS Control Plane:** `ekscicd-eks-cluster` (Kubernetes v1.37, Active).
- **Visual Artifacts:** 
  - `docs/screenshots/ekscicd-day5-vpc-describe.png` — VPC Resource Map architecture view.
  - `docs/screenshots/ekscicd-day5-iam-role.png` — IAM Role permissions and policy attachments.
  - `docs/screenshots/ekscicd-day5-cluster-active.png` — EKS Control Plane active status.
  - `docs/screenshots/ekscicd-day5-nodes-ready.png` — Kubernetes managed worker nodes in `Ready` state.

---

### Phase 2: Infrastructure as Code, CI/CD & Orchestration

- [x] **Day 6: Terraform (Infrastructure as Code)**
  - **Status:** Completed
  - **Deliverable:** Codified network foundation, IAM roles, security groups, and EKS v1.37 architecture into Terraform modules. Established remote state storage backed by S3 with native state locking (`use_lockfile = true`). Cleared legacy "Day 5" manual infrastructure conflicts via AWS CLI teardown and achieved a clean-slate deployment (`Apply complete! Resources: 2 added, 0 changed, 0 destroyed.`). Synchronized all codebase and artifact updates to GitHub.
  - **Visual Artifacts:** 
    - `docs/screenshots/ekscicd-day6-terraform-init.png` — Terminal output verifying successful `terraform init`.
    - `docs/screenshots/ekscicd-day6-terraform-plan-vpc.png` — Terminal output verifying the VPC Terraform plan.
    - `docs/screenshots/ekscicd-day6-terraform-plan-routes.png` — Terminal output verifying the complete network routes plan.
    - `docs/screenshots/ekscicd-day6-terraform-plan-iam-sg.png` — Terminal output verifying the IAM and security group plan.
    - `docs/screenshots/ekscicd-day6-terraform-plan-eks.png` — Terminal output verifying the complete EKS infrastructure plan.
    - `docs/screenshots/ekscicd-day6-terraform-apply-success.png` — Terminal output verifying the successful clean-slate deployment.
    - `docs/screenshots/ekscicd-day6-git-push.png` — Terminal output verifying successful git commit and push to remote GitHub repository.