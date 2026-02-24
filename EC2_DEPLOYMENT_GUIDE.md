# EC2 Deployment & Verification Guide

## Step 1: Connect to EC2 Instance

Open Command Prompt (Windows) or Terminal (Mac/Linux) and run:

```
bash
ssh -i "C:\Users\ASUS\Downloads\task1.pem" ubuntu@65.0.129.64
```

If you're on Windows, you may need to convert the key file permissions:
```
bash
icacls "C:\Users\ASUS\Downloads\task1.pem" /inheritance:r
icacls "C:\Users\ASUS\Downloads\task1.pem" /grant:r "$env:USERNAME:(R)"
```

## Step 2: Check Docker Installation

Once connected to EC2, run:

```
bash
docker --version
docker-compose --version
```

Expected output:
```
Docker version 24.0.0 or higher
Docker Compose version v2.20.0 or higher
```

## Step 3: Install Docker (if not installed)

```
bash
sudo apt update
sudo apt install -y docker.io docker-compose
sudo usermod -aG docker ubuntu
```

Log out and log back in for group changes to take effect.

## Step 4: Create Deployment Directory

```bash
mkdir -p mean-app
cd mean-app
```

## Step 5: Create docker-compose.yml

```
bash
nano docker-compose.yml
```

Paste the following content:

```
yaml
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

  frontend:
    image: sksalahuddin0/mean-frontend:latest
    container_name: frontend
    ports:
      - "80:80"
    depends_on:
      - backend
    networks:
      - mean-network

networks:
  mean-network:
    driver: bridge

volumes:
  mongo-data:
```

Save with Ctrl+O, Enter, then Ctrl+X

## Step 6: Pull and Run Containers

```
bash
sudo docker-compose up -d
```

## Step 7: Check Container Status

```
bash
sudo docker-compose ps
```

Expected output:
```
NAME       IMAGE                          COMMAND                SERVICE    CREATED   STATUS    PORTS
backend    sksalahuddin0/mean-backend     "node server.js"       backend    ...       Up        0.0.0.0:8080->8080/tcp
frontend   sksalahuddin0/mean-frontend    "/docker-entrypoint..." frontend   ...       Up        0.0.0.0:80->80/tcp
mongodb    mongo:6.0                      "docker-entrypoint.s..." mongodb    ...       Up        0.0.0.0:27017->27017/tcp
```

## Step 8: Check Logs

```
bash
sudo docker-compose logs
```

Or for specific service:
```
bash
sudo docker-compose logs backend
sudo docker-compose logs frontend
```

## Step 9: Test Application

### Test Backend API:
```
bash
curl http://localhost:8080/
```

Expected output:
```
json
{"message":"Welcome to Test application."}
```

### Test Frontend:
Open browser and visit:
```
http://65.0.129.64
```

You should see the Angular CRUD application.

## Step 10: Screenshots for README

Take screenshots of:

1. **Container Status**: `sudo docker-compose ps`
2. **Container Logs**: `sudo docker-compose logs`
3. **Backend API Test**: `curl http://localhost:8080/`
4. **Frontend Application**: Browser screenshot of http://65.0.129.64

## Troubleshooting

### If containers are not running:
```
bash
sudo docker-compose down
sudo docker-compose up -d
```

### Check Docker service:
```
bash
sudo systemctl status docker
sudo systemctl restart docker
```

### Check port usage:
```
bash
sudo netstat -tlnp | grep -E '80|8080|27017'
```

### View all logs:
```
bash
sudo docker-compose logs --tail=100
