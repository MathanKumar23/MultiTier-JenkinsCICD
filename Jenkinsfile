pipeline {
    agent any
    
    //tols managed by jenkins
    tools{
        maven 'maven3'
    }
    
    // 
    environment{
        SCANNER_HOME= tool "sonar-scanner"
        IMAGE_NAME = "mathan23/bankapp"
        IMAGE_TAG = "${BUILD_NUMBER}"  // Unique version for each build
    }
    
    stages {
        stage("Git-Checkout"){
            steps{
                git branch: 'Feature/test', credentialsId: 'git-cred', url: 'https://github.com/MathanKumar23/Devops.git'
            }
        }
        stage("Compile"){
            steps{
                sh "mvn compile"
            }
        }
        stage("Unit-Test"){
            steps{
                sh "mvn test -DskipTests=true"
            }
        }
        stage("Trivy FS Scan"){
            steps{
                sh "trivy fs --format table -o fs-report.html ."
            }
        }
        stage("Sonarqube-analysis"){
            steps{
                withSonarQubeEnv('sonar') {
                    sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projetName=Multitier -Dsonar.projectKey=Multitier -Dsonar.java.binaries=target"
                }
                
            }
        }
        stage("Build"){
            steps{
             sh "mvn package -DskipTests=true"   
            }
        }
        stage("Publish to Nexus"){
            steps{
             withMaven(globalMavenSettingsConfig: 'Maven-settings', jdk: '', maven: '', mavenSettingsConfig: '', traceability: true) {
                 sh "mvn deploy -DskipTests=true"
                 
             }  
            }
        }
        stage("Docker image Build"){
            steps{
                script{
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker ') {
                        sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                    }
                }
            }
        }
        stage("Triy images scan"){
            steps{
             sh "trivy image --format table -o fs-report.html ${IMAGE_NAME}:${IMAGE_TAG}"   
            }
        }
        stage("Docker image Push"){
            steps{
                script{
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker ') {
                        sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                    }
                }
            }
        }
        
        stage("Deploy to K8s"){
            steps{
                script {
                    // Replace image tag in Kubernetes manifest
                    sh "sed -i 's|__IMAGE_VERSION__|${IMAGE_TAG}|g' ds.yaml"
                    withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'k8s-token', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
                    sh "kubectl apply -f ds.yaml -n webapps"
                    sleep 30
                    }
                }
            }
        }
        stage("Verify Deployment"){
            steps{
                //withKubeConfig(caCertificate: '', clusterName: 'aks', contextName: '', credentialsId: 'k8-token', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'aks-m44rco14.hcp.westus3.azmk8s.io') {
                withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'k8s-token', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
                    sh "kubectl get pods -n webapps"
                    sh "kubectl get svc -n webapps"
                }
            }
        }
    }
}