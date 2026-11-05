pipeline {
    agent any
    environment {
        AWS_REGION = 'us-east-1'
        ECR_REGISTRY = '891612560987.dkr.ecr.us-east-1.amazonaws.com'
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
                    sh "docker build -t ${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} -f app/Dockerfile app/"
                }
            }
        }
        stage('Push to ECR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-secret-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh """
                        aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
                        docker push ${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }
        stage('Deploy to EKS') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-secret-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh """
                        aws eks update-kubeconfig --region ${AWS_REGION} --name ekscicd-eks-cluster
                        kubectl apply -f k8s/storage.yaml
                        sed 's|image:.*|image:${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}|g' k8s/deployment.yaml | kubectl apply -f -
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