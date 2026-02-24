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

## Screenshots Checklist - How to Verify

### 1. CI/CD Pipeline Configuration in Jenkins
```
# On EC2, access Jenkins UI
# http://<EC2-IP>:8080

# Steps to verify:
1. Login to Jenkins dashboard
2. Navigate to your Pipeline job
3. Take screenshot of Pipeline configuration page
4. Screenshot should show:
   - GitHub repository URL configured
   - Jenkinsfile script
   - Build triggers configuration
```

### 2. Docker Image Build and Push to Docker Hub
```
# On Jenkins console output or local terminal:

# Build and push commands:
docker build -t sksalahuddin0/mean-backend ./backend
docker build -t sksalahuddin0/mean-frontend ./frontend
docker push sksalahuddin0/mean-backend
docker push sksalahuddin0/mean-frontend

# Verify on Docker Hub:
# Visit: https://hub.docker.com/u/sksalahuddin0
# Take screenshot of both images listed
```

### 3. Application Running on EC2
```
# SSH into EC2 and check:
ssh -i your-key.pem ubuntu@<EC2-IP>

# Check containers running:
sudo docker ps

# Should show 3 containers:
# - mean-backend
# - mean-frontend  
# - mongodb

# Test API:
curl http://localhost:8080/
# Expected: {"message":"Welcome to Test application."}

# Test from browser:
# http://<EC2-IP>
# Take screenshot of the application landing page
```

### 4. Working UI - Tutorial List Page
```
# In browser, navigate to: http://<EC2-IP>

# Take screenshot showing:
- Header "Tutorials"
- Table with columns: Title, Description, Status, Actions
- "No tutorials found" message OR list of tutorials
- "Add New Tutorial" button
```

### 5. Add Tutorial Functionality
```
# In browser:
1. Click "Add New Tutorial" button
2. Fill in:
   - Title: "Test Tutorial"
   - Description: "This is a test"
   - Check/uncheck "Published"
3. Click "Save"

# Take screenshot of:
- Form filled with data
- Success message OR updated list

# Verify in API:
curl http://localhost:8080/api/tutorials
```

### 6. Edit/Delete Tutorial Functionality
```
# In browser, on tutorial list:
1. Click "Edit" button on a tutorial
2. Modify title/description
3. Click "Update"

4. Click "Delete" button on a tutorial
5. Confirm deletion

# Take screenshot of:
- Edit form with pre-filled data
- Updated list after edit/delete
```

### 7. Search Functionality
```
# In browser:
1. Type in the search box: "test"
2. Click "Search" button

# Take screenshot of:
- Search results filtered by title
- "No results found" if no match
```

### 8. Nginx Configuration and Logs
```
# On EC2, check Nginx config:
sudo docker exec mean-frontend cat /etc/nginx/conf.d/default.conf

# Check Nginx logs:
sudo docker logs mean-frontend

# Check access logs:
sudo docker exec mean-frontend tail -f /var/log/nginx/access.log

# Take screenshot of:
- Nginx configuration file content
- Nginx logs showing requests

# Verify reverse proxy working:
curl http://localhost/api/tutorials
# Should return JSON from backend
```

---

## Screenshots Checklist (Mark as Complete)

- ## CI/CD Pipeline configuration in Jenkins
<img width="1920" height="1020" alt="65 0 129 64_8080 - Google Chrome 24-02-2026 18_47_53" src="https://github.com/user-attachments/assets/0e6b3c35-f175-4e41-8fe3-72dded3e8a56" />

- ## Docker image build and push to Docker Hub
<img width="1920" height="1020" alt="EC2 Instance Connect _ ap-south-1 - Google Chrome 24-02-2026 18_39_11" src="https://github.com/user-attachments/assets/cc514a44-9a1f-4fbd-b98a-0507bacbbaad" />

- ## Application running on EC2 
<img width="1920" height="1020" alt="DD Task - Google Chrome 24-02-2026 18_40_19" src="https://github.com/user-attachments/assets/37dbc006-c7d6-466c-b1c9-c2b51df68850" />
<img width="1920" height="1020" alt="DD Task - Google Chrome 24-02-2026 18_42_16" src="https://github.com/user-attachments/assets/31c39ee3-bab2-4ed4-bca7-2fa4f365b428" />

- ## Video


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
