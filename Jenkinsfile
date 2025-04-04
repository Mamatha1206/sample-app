pipeline {
    agent any

    environment {
        GITHUB_REPO_URL = "https://github.com/Mamatha1206/sample-app.git" // 🔹 Replace with your repo URL
        BRANCH_NAME = "main"  // 🔹 Replace with the branch you want to use
        DOCKER_IMAGE = "mamatha0124/sample-app:latest"
        DOCKER_CREDENTIALS_ID = "DOCKER_CREDENTIALS_ID"
        KUBECONFIG = "/root/.kube/config"  // Update if needed
    }

    stages {
        stage('Checkout Code') {
            steps {
                script {
                    echo "Cloning the repository from ${GITHUB_REPO_URL} (Branch: ${BRANCH_NAME})..."
                    git branch: "${main}", url: "${https://github.com/Mamatha1206/sample-app.git}"
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    echo "Installing Python dependencies..."
                    sh 'pip install -r requirements.txt'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image..."
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    echo "Pushing Docker image to DockerHub..."
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                        sh "docker push ${DOCKER_IMAGE}"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    echo "Applying Kubernetes deployment and service..."
                    sh "kubectl apply -f deployment.yaml"
                    sh "kubectl apply -f service.yaml"
                }
            }
        }
    }

    post {
        success {
            echo "Deployment successful! Application is live."
        }
        failure {
            echo "Deployment failed! Check logs for issues."
        }
    }
}
