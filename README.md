# Multi-Tier Jenkins CI/CD Pipeline with Terraform, Jenkins, SonarQube, Nexus, and AKS

This project demonstrates a multi-tier CI/CD pipeline using Jenkins, Terraform, SonarQube, Nexus, and Azure Kubernetes Service (AKS). The pipeline automates the deployment of a Spring Boot application (`bankapp`) to AKS after provisioning the infrastructure using Terraform.

For a **detailed step-by-step guide**, check out my Medium blog:  
👉 [Medium Blog: Multi-Tier Jenkins CI/CD Pipeline with Terraform, Jenkins, SonarQube, Nexus, and AKS](https://medium.com/@mathankumararumugasamy/multi-tier-jenkins-ci-cd-pipeline-with-terraform-jenkins-sonarqube-nexus-and-aks-3c7f5546c145)

## Table of Contents

1. [Project Overview](#project-overview)
2. [Infrastructure Provisioning](#infrastructure-provisioning)
3. [Tools and Software Setup](#tools-and-software-setup)
4. [Jenkins Pipeline Configuration](#jenkins-pipeline-configuration)
5. [Deploying the Application](#deploying-the-application)
6. [Accessing the Application](#accessing-the-application)
7. [Repository Structure](#repository-structure)
8. [Contributing](#contributing)

---

## Project Overview

This project automates the deployment of a Spring Boot application (`bankapp`) using the following tools and technologies:

- **Terraform**: For provisioning infrastructure on Azure (VNet, Subnets, NIC, Public IP, VM, AKS).
- **Jenkins**: For orchestrating the CI/CD pipeline.
- **SonarQube**: For static code analysis and quality checks.
- **Nexus**: For artifact storage and management.
- **Docker and DockerHub**: For Build and push the docker images
- **AKS (Azure Kubernetes Service)**: For deploying the application.

The pipeline includes steps for building, testing, analyzing, containerizing, and deploying the application to AKS.

---

## Infrastructure Provisioning

The infrastructure is provisioned using Terraform. The following resources are created:

- **VNet and Subnets**: For network isolation.
- **NIC and Public IP**: For VM connectivity.
- **VM**: Hosts Jenkins, SonarQube, and Nexus.
- **AKS**: For deploying the application.
- **null resource**: For Script execution, we can easily taint and reeecute, without recreating VM

### Steps to Provision Infrastructure:

1. Navigate to the `Infra_Terraform` folder in the repository.
2. Run the following Terraform commands:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```
3. Once the infrastructure is provisioned, the VM will have Jenkins, SonarQube, and Nexus installed automatically using 'remote-exec' provisioners. These provisioners execute scripts on the VM to install and configure the required tools.

### Tools and Software Setup

After provisioning the infrastructure, the following tools are set up on the VM:

1. Jenkins

- Access Jenkins at http://<public-ip>:8080.
- Default password is stored in /var/lib/jenkins/secrets/initialAdminPassword.
- Create a new user and install the required plugins:
  SonarQube Scanner
  Config File Provider
  Maven Integration
  Pipeline Maven Integration
  Docker plugins
  Kubernetes plugins

2. SonarQube

- Access SonarQube at http://<public-ip>:9000.
- Default username: admin, default password: admin.
- Create a new password after the first login.

3. Nexus

- Access Nexus at http://<public-ip>:8081.
- Default password is stored in /nexus-data/admin.password.

### Jenkins Pipeline Configuration

1. Configure Tools in Jenkins:

- Add Maven, Docker, and Kubernetes CLI.
- Add credentials for Git (if using a private repository), Docker, and Kubernetes.

2. Configure SonarQube Server:

- Go to Manage Jenkins > Configure System
- Add SonarQube server details.

3. Configure Nexus in Maven Settings:

   - Go to Manage Jenkins > Managed Files.
   - Add a new config file: Global Maven settings.xml.
   - Add Nexus server details to the settings.xml.

4. Jenkinsfile

- The Jenkinsfile in the repository defines the pipeline stages:
  Checkout code
  Build the application using Maven
  Run SonarQube analysis
  Build and push Docker images
  Deploy to AKS

### Deploying the Application

1. Update the pom.xml file:

- Modify the <distributionManagement> block with your Nexus repository details.

2. Run the Jenkins pipeline:

- Create a new pipeline job in Jenkins.
- Point it to the Jenkinsfile in this repository.
- Start the pipeline.

3. The pipeline will:

- Build the application.
- Run SonarQube analysis.
- Build and push the Docker image to the registry.
- Deploy the application to AKS..

### Accessing the Application

Once the pipeline completes successfully, the application will be deployed to AKS. You can access it using the LoadBalancer IP provided by AKS

### Repository Structure

MultiTier-JenkinsCICD/
├── Infra_Terraform/ # Terraform configuration files for infrastructure provisioning
├── src/ # Spring Boot application source code
├── Jenkinsfile # Jenkins pipeline definition
├── pom.xml # Maven configuration file
├── Dockerfile # Dockerfile for image
├── k8s.yaml # App, DB deployment and service file
└── README.md # Project documentation

### Contributing

Contributions are welcome! If you find any issues or have suggestions for improvement, please open an issue or submit a pull request.
