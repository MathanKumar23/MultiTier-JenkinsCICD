#!/bin/bash
set -x
sudo apt update
sudo apt install nginx -y
sudo apt install git -y

# Intsalling Java
### Jenkins ###
sudo apt update -y
sudo apt install openjdk-17-jre -y
java --version

# Installing Jenkins
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc >/dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list >/dev/null
sudo apt-get update -y
sudo apt-get install jenkins -y

### Azure Cli ###
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

### Docker ###
sudo apt update
sudo apt install docker.io -y
sudo usermod -aG docker jenkins
sudo usermod -aG docker azureuser
# newgrp docker

### Sonarqube ###
docker run -d --name Sonarqube -p 9000:9000 sonarqube:lts-community

### Nexus3 Installation using docker ###
# docker run -d --name Nexus3 -p 8081:8081 sonatype/nexus3:latest

### Kubectl ###
sudo apt update
sudo apt install curl
curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

echo "Installation complete"
exit 0
