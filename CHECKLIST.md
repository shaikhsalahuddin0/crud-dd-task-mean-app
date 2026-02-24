# How to Check Screenshots Checklist

## 1. CI/CD Pipeline Configuration in Jenkins
- Access Jenkins at http://<EC2-IP>:8080
- Login to Jenkins dashboard
- Navigate to your Pipeline job
- Take screenshot showing: GitHub repository URL, Jenkinsfile script, Build triggers

## 2. Docker Image Build and Push to Docker Hub
- Run: docker build -t sksalahuddin0/mean-backend ./backend
- Run: docker build -t sksalahuddin0/mean-frontend ./frontend
- Run: docker push sksalahuddin0/mean-backend
- Run: docker push sksalahuddin0/mean-frontend
- Visit: https://hub.docker.com/u/sksalahuddin0 and take screenshot of both images

## 3. Application Running on EC2
- SSH: ssh -i your-key.pem ubuntu@<EC2-IP>
- Run: sudo docker ps (should show 3 containers)
- Run: curl http://localhost:8080/ (should return JSON)
- Open browser: http://<EC2-IP> - take screenshot

## 4. Working UI - Tutorial List Page
- Open browser: http://<EC2-IP>
- Take screenshot showing: Header "Tutorials", Table with columns, "Add New Tutorial" button

## 5. Add Tutorial Functionality
- Click "Add New Tutorial" button
- Fill form with Title, Description
- Click "Save"
- Take screenshot of form and success

## 6. Edit/Delete Tutorial Functionality
- Click "Edit" on a tutorial
- Modify and click "Update"
- Click "Delete" on a tutorial
- Take screenshots of edit form and updated list

## 7. Search Functionality
- Type in search box
- Click "Search" button
- Take screenshot of filtered results

## 8. Nginx Configuration and Logs
- Run: sudo docker exec mean-frontend cat /etc/nginx/conf.d/default.conf
- Run: sudo docker logs mean-frontend
- Run: curl http://localhost/api/tutorials
- Take screenshots of config and logs
