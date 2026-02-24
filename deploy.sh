#!/bin/bash

# MEAN Stack Application Deployment Script for EC2
# EC2 Details: ubuntu@65.0.129.64

echo "=== MEAN Stack Deployment Script ==="

# SSH into EC2 and run deployment commands
ssh -i "C:/Users/ASUS/Downloads/task1.pem" ubuntu@65.0.129.64 << 'EOF'

echo "Updating system..."
sudo apt update && sudo apt upgrade -y

echo "Installing Docker..."
sudo apt install -y docker.io docker-compose

echo "Adding ubuntu user to docker group..."
sudo usermod -aG docker ubuntu

echo "Installing Docker Compose standalone..."
sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Creating deployment directory..."
mkdir -p mean-app
cd mean-app

echo "Creating docker-compose.yml..."
cat > docker-compose.yml << 'COMPOSE'
version: '3.8'

services:
  mongodb:
    image: mongo:6.0
    container_name: mongodb
    ports:
      - "27017:27017"
    volumes:
      - mongo-data:/data/db
    networks:
      - mean-network

  backend:
    image: sksalahuddin0/mean-backend:latest
    container_name: backend
    ports:
      - "8080:8080"
    environment:
      - MONGO_URI=mongodb://mongodb:27017/dd_db
    depends_on:
      - mongodb
    networks:
      - mean-network
    restart: unless-stopped

  frontend:
    image: sksalahuddin0/mean-frontend:latest
    container_name: frontend
    ports:
      - "80:80"
    depends_on:
      - backend
    networks:
      - mean-network
    restart: unless-stopped

networks:
  mean-network:
    driver: bridge

volumes:
  mongo-data:
COMPOSE

echo "Starting containers..."
docker-compose up -d

echo "Checking container status..."
docker-compose ps

echo "Container logs..."
docker-compose logs --tail=20

echo "=== Deployment Complete ==="
echo "Application should be accessible at: http://65.0.129.64"
echo "API available at: http://65.0.129.64:8080"

EOF
