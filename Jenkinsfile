pipeline {
    agent any

    environment {
        GITHUB_REPO_URL = "https://github.com/Mamatha1206/sample-app.git"
        BRANCH_NAME = "main"
        DOCKER_IMAGE = "mamatha0124/sample-app:latest"
        DOCKER_CREDENTIALS_ID = "DOCKER_CREDENTIALS_ID"
        KUBECONFIG = "/var/lib/jenkins/.kube/config"  // Fixed KUBECONFIG path for Jenkins
        VENV_DIR = "venv"  // Virtual environment directory
    }

    stages {
        stage('Checkout Code') {
            steps {
                script {
                    echo "Cloning the repository..."
                    git branch: "${BRANCH_NAME}", url: "${GITHUB_REPO_URL}"
                }
            }
        }

        stage('Setup Virtual Environment & Install Dependencies') {
            steps {
                script {
                    echo "Setting up a Python virtual environment..."
                    sh '''
                        python3 -m venv ${VENV_DIR}
                        source ${VENV_DIR}/bin/activate
                        pip install --upgrade pip
                        pip install -r requirements.txt
                    '''
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
                        sh '''
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                            docker push ${DOCKER_IMAGE}
                        '''
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    echo "Deploying to Kubernetes..."
                    sh '''
                        export KUBECONFIG=${KUBECONFIG}
                        kubectl apply -f deployment.yaml || { echo "Failed to apply deployment"; exit 1; }
                        kubectl apply -f service.yaml || { echo "Failed to apply service"; exit 1; }
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful! Application is live."
        }
        failure {
            echo "❌ Deployment failed! Check logs for issues."
        }
    }
}
