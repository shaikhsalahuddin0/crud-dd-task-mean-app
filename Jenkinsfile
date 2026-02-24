pipeline {
    agent any
    
    environment {
        DOCKER_USERNAME = 'sksalahuddin0'
        DOCKER_IMAGE_BACKEND = 'sksalahuddin0/mean-backend'
        DOCKER_IMAGE_FRONTEND = 'sksalahuddin0/mean-frontend'
        EC2_HOST = '18.212.123.45'  // Replace with your EC2 public IP
        EC2_USER = 'ubuntu'
        EC2_KEY = credentials('ec2-ssh-key')  // Jenkins credential ID for SSH key
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }
        
        stage('Build Backend Docker Image') {
            steps {
                echo 'Building backend Docker image...'
                dir('backend') {
                    sh """
                        docker build -t ${DOCKER_IMAGE_BACKEND}:${BUILD_NUMBER} .
                        docker tag ${DOCKER_IMAGE_BACKEND}:${BUILD_NUMBER} ${DOCKER_IMAGE_BACKEND}:latest
                    """
                }
            }
        }
        
        stage('Build Frontend Docker Image') {
            steps {
                echo 'Building frontend Docker image...'
                dir('frontend') {
                    sh """
                        docker build -t ${DOCKER_IMAGE_FRONTEND}:${BUILD_NUMBER} .
                        docker tag ${DOCKER_IMAGE_FRONTEND}:${BUILD_NUMBER} ${DOCKER_IMAGE_FRONTEND}:latest
                    """
                }
            }
        }
        
        stage('Push Images to Docker Hub') {
            steps {
                echo 'Logging in to Docker Hub and pushing images...'
                sh """
                    echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin
                    docker push ${DOCKER_IMAGE_BACKEND}:${BUILD_NUMBER}
                    docker push ${DOCKER_IMAGE_BACKEND}:latest
                    docker push ${DOCKER_IMAGE_FRONTEND}:${BUILD_NUMBER}
                    docker push ${DOCKER_IMAGE_FRONTEND}:latest
                    docker logout
                """
            }
        }
        
        stage('Deploy to EC2') {
            steps {
                echo 'Deploying to EC2...'
                sh """
                    ssh -o StrictHostKeyChecking=no -i \${EC2_KEY} \${EC2_USER}@\${EC2_HOST} << 'EOF'
                        cd /home/ubuntu/mean-app
                        
                        # Pull latest images
                        docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}
                        docker pull ${DOCKER_IMAGE_BACKEND}:latest
                        docker pull ${DOCKER_IMAGE_FRONTEND}:latest
                        docker logout
                        
                        # Stop and remove old containers
                        docker-compose down
                        
                        # Start services with new images
                        docker-compose up -d
                        
                        echo "Deployment completed successfully!"
                    EOF
                """
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
