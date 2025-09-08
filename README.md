# K8s-Project  
Kubernetes Rolling Project – AWS Dashboard

## Project Goal  
A containerized **Flask** app that connects to **AWS** and displays:  
- EC2 instances  
- VPCs  
- Load Balancers  
- AMIs  

All in a simple web UI.  


## Why These Choices  

- **Docker** →                   consistent runtime, no local dependency issues, portable across environments.  
- **Flask** →                    lightweight, fast to set up, great for small dashboards/APIs.  
- **Boto3** →                    official AWS SDK for Python, handles authentication and API calls directly.  
- **Region: us-east-1** →        common AWS default, easy to test with.  


## Dockerfile Overview  

- **Base image**: `python:3.11-slim` → small, secure, faster build times.  
- **ENV settings**:  
  - `PYTHONDONTWRITEBYTECODE=1` → avoids `.pyc` files.  
  - `PYTHONUNBUFFERED=1` → ensures logs flush immediately.  
- **Workdir**: `/app` → keeps code organized.  
- **Installed curl** → useful for debugging inside container.  
- **Copy requirements.txt first** → enables Docker layer caching.  
- **Install dependencies**: `pip install --no-cache-dir -r requirements.txt` → smaller image.  
- **Copy rest of project** → adds app code.  
- **CMD**: `["python", "main.py"]` → starts Flask app.  

## App Flow (main.py)  

1. Fetch AWS credentials from environment variables → secure, no hardcoding.  
2. Create **Boto3 session** → used for EC2 + ELB clients.  
3. Flask route `/` → queries AWS for:  
   - **EC2 instances** → ID, state, type, IP.  
   - **VPCs** → ID, CIDR.  
   - **Load Balancers** → Name, DNS.  
   - **AMIs** → AMI ID, Name.  
4. Render results in **HTML tables** → easy to read.  
5. App runs on `0.0.0.0:5001` → accessible from outside container.  

## Requirements  

- `flask`  
- `boto3`  

Installed during Docker build so container is self-contained.  

## How to Run  

### Option 1: Build locally  
```bash
docker build -t aws-dashboard .
docker run -p 5001:5001 \
  -e AWS_ACCESS_KEY_ID=xxx \
  -e AWS_SECRET_ACCESS_KEY=yyy \
  aws-dashboard
```

Option 2: Pull from Docker Hub
Skip building and use the prebuilt image:
```
docker pull omribe/aws-dashboard:latest
docker run -p 5001:5001 \
  -e AWS_ACCESS_KEY_ID=xxx \
  -e AWS_SECRET_ACCESS_KEY=yyy \
```
