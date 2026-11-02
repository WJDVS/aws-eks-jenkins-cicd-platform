pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        ECR_REGISTRY = 'your-account-id.dkr.ecr.us-east-1.amazonaws.com'
        IMAGE_NAME = 'cloudpath-node-app'
    }

    stages {
        stage('Checkout Source') {
            steps {
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                echo 'Building Node.js application and running verification tests...'
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                echo 'Tagging container image with Git commit SHA and pushing to Amazon ECR...'
            }
        }

        stage('Deploy to EKS') {
            steps {
                echo 'Deploying application manifests to Amazon EKS v1.37 cluster...'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
