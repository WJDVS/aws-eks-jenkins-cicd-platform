pipeline {
    agent any
    environment {
        AWS_REGION = 'us-east-1'
        ECR_REGISTRY = '891612560987.ecr.us-east-1.amazonaws.com'
        IMAGE_NAME = 'cloudpath-node-app'
        IMAGE_TAG = "${env.GIT_COMMIT ?: 'latest'}"
    }
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    app = docker.build("${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}", "-f app/Dockerfile app/")
                }
            }
        }
        stage('Push to ECR') {
            steps {
                script {
                    awsEcrLogin(region: "${AWS_REGION}", credentialsId: "aws-secret-credentials")
                    app.push()
                }
            }
        }
        stage('Deploy to EKS') {
            steps {
                withCredentials([aws(credentialsId: 'aws-secret-credentials', region: "${AWS_REGION}")]) {
                    sh """
                        aws eks update-kubeconfig --region ${AWS_REGION} --name ekscicd-eks-cluster
                        kubectl apply -f k8s/storage.yaml
                        kubectl sed 's|image:.*|image:${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}|g' k8s/deployment.yaml | kubectl apply -f -
                    """
                }
            }
        }
    }
    post {
        success {
            echo 'Pipeline completed successfully! Workload deployed to EKS.'
        }
        failure {
            echo 'Pipeline failed during execution. Check logs.'
        }
    }
}