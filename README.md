# Spring Boot Common Infrastructure

This repository provides the infrastructure setup for deploying microservices on an AWS EKS (Elastic Kubernetes Service) cluster. It focuses on best practices for organizing repositories and managing infrastructure components like VPC, ACM, EKS, Prometheus, Grafana, and Alert Manager. The goal is to separate concerns for scalability and maintainability.

## Repository Structure

The repository is divided into multiple folders based on the components needed to deploy and manage microservices on EKS. Each folder represents a specific part of the infrastructure and is designed for modularity and independence.

### Folder Breakdown

1. **`vpc/`**  
   Contains Terraform code for provisioning the Virtual Private Cloud (VPC), including subnets, security groups, and internet gateway configurations.

2. **`acm/`**  
   Manages AWS Certificate Manager (ACM) for SSL/TLS certificates, ensuring secure access to microservices via browsers.

3. **`eks/`**  
   Contains Terraform configuration for creating the EKS cluster.

4. **`monitoring/`**  
   Houses the Terraform configurations for deploying Prometheus, Grafana, and Alert Manager, separated for clear management and easy modification without affecting the rest of the infrastructure.

### **Modular Infrastructure Design**

This repository follows a modular approach:
- Each component (VPC, ACM, EKS, monitoring) is managed in its own folder.
- This separation ensures that changes made to the VPC do not affect the EKS cluster, and vice versa.
- You can update or modify a specific component without impacting others, adhering to best practices for infrastructure as code.

### **Provider Version Management**

- We specify the Terraform provider version with a major version lock, ensuring stability while automatically updating to the latest patch releases.
- The provider version will always remain at version 5.x, ensuring compatibility with new features and bug fixes while avoiding breaking changes.

### **Resource Naming Convention**

- A consistent naming convention is followed for resources to ensure clarity and avoid conflicts.
- Resource names are structured to include identifiers for the environment, region, and resource type.

## Terraform Best Practices

- **State Management**: We use an S3 bucket to manage Terraform state files, ensuring state is securely stored and shared across multiple team members.
- **Modules**: Terraform modules are used to encapsulate reusable logic, ensuring that infrastructure components can be replicated or modified easily.
- **GitHub Workflows**:
  - **PR Workflow**: Automatically triggers the validation and review of Terraform code whenever a pull request (PR) is created or updated.
  - **CD Workflow**: Automatically detects changes in specific folders and triggers the deployment of those components.


## Issues
   ingress  Failed deploy model due to operation error Elastic Load Balancing v2: CreateLoadBalancer, https response error StatusCode: 400, RequestID: f7b233cd-2822-4396-a539-7db524243ef8, DuplicateLoadBalancerName: A load balancer with the same name 'dev-alb' exists, but with different settings

hi
