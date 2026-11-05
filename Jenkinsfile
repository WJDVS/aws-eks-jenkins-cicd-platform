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
                    sh '''
                        # 1. Full image name built from the environment block (same image Build/Push used)
                        IMAGE_URI="${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"

                        # 2. Point kubectl at the EKS cluster
                        aws eks update-kubeconfig --region "${AWS_REGION}" --name ekscicd-eks-cluster

                        # 3. Storage first (StorageClass + PVC the pod depends on)
                        kubectl apply -f k8s/storage.yaml

                        # 4. Render a copy: strip Windows line endings, then swap ONLY the placeholder
                        tr -d '\\r' < k8s/test-pod.yaml |
                            sed "s|DOCKER_IMAGE_PLACEHOLDER|${IMAGE_URI}|g" > k8s/test-pod.rendered.yaml

                        # 5. Show the final YAML in the Jenkins log
                        echo "----- rendered manifest -----"
                        cat k8s/test-pod.rendered.yaml

                        # 6. Validate without changing the cluster, then deploy
                        kubectl apply --dry-run=client -f k8s/test-pod.rendered.yaml
                        kubectl apply -f k8s/test-pod.rendered.yaml

                        # 7. Confirm which image the pod is running
                        kubectl get pod app-pod -o jsonpath='{.spec.containers[0].image}'; echo
                    '''
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