pipeline {
    agent any
    
    //tols managed by jenkins
    tools{
        maven 'maven3'
    }
    
    // 
    environment{
        SCANNER_HOME= tool "sonar-scanner"
    }
    
    stages {
        stage("Git-Checkout"){
            steps{
                git branch: 'main', credentialsId: 'git-cred', url: 'https://github.com/MathanKumar23/Devops.git'
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
             sh "mvn install -DskipTests=true"   
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
                        sh "docker build -t mathan23/bankapp:latest ."
                    }
                }
            }
        }
        stage("Triy images scan"){
            steps{
             sh "trivy image --format table -o fs-report.html mathan23/bankapp:latest"   
            }
        }
        stage("Docker image Push"){
            steps{
                script{
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker ') {
                        sh "docker push mathan23/bankapp:latest"
                    }
                }
            }
        }
    }
}
