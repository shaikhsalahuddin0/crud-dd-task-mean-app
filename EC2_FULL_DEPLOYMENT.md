# Complete EC2 Deployment Guide
# Run ALL commands on your local machine to deploy to EC2

## Step 1: Connect to EC2 from your local terminal

Open Command Prompt (Windows) or Terminal (Mac/Linux) and run:

```
ssh -i "C:\Users\ASUS\Downloads\task1.pem" ubuntu@65.0.129.64
```

## Step 2: Install Docker and Docker Compose (Run on EC2)

```
sudo apt update
sudo apt install -y docker.io docker-compose git
```

## Step 3: Add user to docker group (Run on EC2)

```
sudo usermod -aG docker ubuntu
```

## Step 4: Log out and reconnect to EC2, then clone repository (Run on EC2)

```
git clone https://github.com/shaikhsalahuddin0/crud-dd-task-mean-app.git
cd crud-dd-task-mean-app
```

## Step 5: Build Docker images locally on EC2 (Run on EC2)

```
cd crud-dd-task-mean-app/backend
docker build -t sksalahuddin0/mean-backend:latest .
cd ../frontend
docker build -t sksalahuddin0/mean-frontend:latest .
```

## Step 6: Login to Docker Hub (Run on EC2)

```
docker login
# Enter your Docker Hub username: sksalahuddin0
# Enter your Docker Hub password
```

## Step 7: Push images to Docker Hub (Run on EC2)

```
docker push sksalahuddin0/mean-backend:latest
docker push sksalahuddin0/mean-frontend:latest
```

## Step 8: Run the application with Docker Compose (Run on EC2)

```
cd crud-dd-task-mean-app
sudo docker-compose up -d
```

## Step 9: Check if application is running (Run on EC2)

```
sudo docker-compose ps
```

You should see:
- mongodb    (Up)
- backend    (Up)
- frontend   (Up)

## Step 10: Test the application

### Test Backend API:
```
curl http://localhost:8080/
```

Expected output: `{"message":"Welcome to Test application."}`

### Test Frontend:
Open your browser and visit:
```
http://65.0.129.64
```

You should see the Angular CRUD application!

## Quick Summary - Commands to run on EC2 (in order):

```
1. ssh -i "C:\Users\ASUS\Downloads\task1.pem" ubuntu@65.0.129.64

2. sudo apt update && sudo apt install -y docker.io docker-compose git

3. sudo usermod -aG docker ubuntu

4. git clone https://github.com/shaikhsalahuddin0/crud-dd-task-mean-app.git

5. cd crud-dd-task-mean-app/backend && docker build -t sksalahuddin0/mean-backend:latest .

6. cd ../frontend && docker build -t sksalahuddin0/mean-frontend:latest .

7. docker login (enter your Docker Hub credentials)

8. docker push sksalahuddin0/mean-backend:latest

9. docker push sksalahuddin0/mean-frontend:latest

10. cd .. && sudo docker-compose up -d

11. curl http://localhost:8080/

12. Open browser: http://65.0.129.64
```

## Screenshots to capture for README:

1. After Step 11 - Terminal showing: `{"message":"Welcome to Test application."}`
2. After Step 12 - Browser screenshot of http://65.0.129.64 showing the Angular CRUD application
3. `sudo docker-compose ps` showing all containers running
