# MEAN Stack CRUD Application - Deployment Guide

A complete full-stack MEAN (MongoDB, Express, Angular, Node.js) application with Docker containerization and CI/CD deployment using Jenkins.

## Application Overview

This is a Tutorial Management CRUD application where users can:
- Create new tutorials with title, description, and published status
- View all tutorials in a list
- Edit existing tutorials
- Delete tutorials
- Search tutorials by title

### Technology Stack
- **Frontend**: Angular 15
- **Backend**: Node.js + Express
- **Database**: MongoDB
- **Containerization**: Docker & Docker Compose
- **Reverse Proxy**: Nginx
- **CI/CD**: Jenkins

---

## Project Structure

```
crud-dd-task-mean-app/
├── backend/
│   ├── Dockerfile              # Backend container image
│   ├── package.json
│   ├── server.js
│   └── app/
│       ├── config/db.config.js
│       ├── controllers/
│       ├── models/
│       └── routes/
├── frontend/
│   ├── Dockerfile              # Frontend container image
│   ├── nginx.conf              # Nginx configuration
│   ├── package.json
│   └── src/
├── docker-compose.yml           # Orchestrates all services
├── Jenkinsfile                  # CI/CD pipeline
└── README.md
```

---

## Local Development Setup

### Prerequisites
- Node.js 18+
- Docker and Docker Compose
- MongoDB (or use Docker)

### Backend Setup
```
bash
cd backend
npm install
npm start
```
Backend runs on: http://localhost:8080

### Frontend Setup
```
bash
cd frontend
npm install
ng serve --port 8081
```
Frontend runs on: http://localhost:8081

---

## Docker Deployment (Manual)

### Building Images Locally

1. **Build Backend Image:**
```
bash
cd backend
docker build -t mean-backend .
```

2. **Build Frontend Image:**
```
bash
cd frontend
docker build -t mean-frontend .
```

3. **Run with Docker Compose:**
```
bash
docker-compose up -d
```

### Access the Application
- Frontend (via Nginx): http://localhost
- Backend API: http://localhost:8080
- MongoDB: localhost:27017

---

## EC2 Deployment with Docker Compose

### Step 1: Launch EC2 Instance
1. Go to AWS EC2 Console
2. Launch Ubuntu 22.04 LTS instance
3. Configure Security Group:
   - Open port 80 (HTTP)
   - Open port 22 (SSH)
   - Open port 8080 (for backend access if needed)

### Step 2: Install Docker on EC2
```
bash
# Update system
sudo apt update
sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com | sh

# Add user to docker group
sudo usermod -aG docker ubuntu

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker --version
docker-compose --version
```

### Step 3: Deploy Application
```

# Clone the repository
git clone https://github.com/shaikhsalahuddin0/crud-dd-task-mean-app.git
cd crud-dd-task-mean-app

# Start the application
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f
```

---

## CI/CD Pipeline with Jenkins

### Jenkins Setup on EC2

1. **Install Java and Jenkins:**
```
bash
# Install Java
sudo apt update
sudo apt install openjdk-11-jdk -y

# Add Jenkins repository
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo tee /etc/apt/trusted.gpg.d/jenkins.asc
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# Install Jenkins
sudo apt update
sudo apt install jenkins -y

# Start Jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
```

2. **Access Jenkins:**
- URL: http://your-ec2-ip:8080
- Get initial admin password: `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`

3. **Configure Jenkins Credentials:**
- Go to Manage Jenkins → Manage Credentials
- Add Docker Hub credentials (ID: docker-hub)
- Add SSH key for EC2 (ID: ec2-ssh-key)

### Jenkins Pipeline Configuration

1. Create a new Pipeline job
2. Configure GitHub repository: https://github.com/shaikhsalahuddin0/crud-dd-task-mean-app.git
3. Select "Pipeline script from SCM"
4. Add Jenkins credentials for Docker Hub and EC2

### Pipeline Stages
1. **Checkout** - Pull latest code from GitHub
2. **Build Backend** - Build Docker image for backend
3. **Build Frontend** - Build Docker image for frontend
4. **Push Images** - Push images to Docker Hub
5. **Deploy to EC2** - Pull images and restart containers on EC2

### Docker Hub Images
- Backend: `sksalahuddin0/mean-backend:latest`
- Frontend: `sksalahuddin0/mean-frontend:latest`

---

## Nginx Configuration

The Nginx server acts as a reverse proxy:
- Serves Angular static files on port 80
- Proxies API requests to backend container

### Request Flow
```
User Request (Port 80)
       ↓
    Nginx
       ↓
   /api/* → Backend:8080
   /*      → Angular Static Files
```

---

## Troubleshooting

### Check Container Logs
```
bash
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f mongodb
```

### Restart Services
```
bash
docker-compose restart
```

### Rebuild Images
```
bash
docker-compose build --no-cache
docker-compose up -d
```

### Access Container Shell
```
bash
docker exec -it backend sh
docker exec -it mongodb mongosh
```

---

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| PORT | 8080 | Backend server port |
| MONGO_URI | mongodb://mongodb:27017/dd_db | MongoDB connection string |

---

## Screenshots Checklist

- [ ] CI/CD Pipeline configuration in Jenkins
- [ ] Docker image build and push to Docker Hub
- [ ] Application running on EC2 (http://<ec2-ip>)
- [ ] Working UI - Tutorial list page
- [ ] Add Tutorial functionality
- [ ] Edit/Delete Tutorial functionality
- [ ] Search functionality
- [ ] Nginx configuration and logs

---

## Clean Up

### Stop Application
```
bash
docker-compose down
```

### Remove All Data
```
bash
docker-compose down -v
```

### Remove Images
```
bash
docker rmi mean-backend mean-frontend
```

---
