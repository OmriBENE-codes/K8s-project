# K8s-project
Kubernetes rolling project
README

. Project goal: containerized Flask app that connects to AWS and shows EC2, VPCs, Load Balancers, and AMIs in a simple web UI.
. Reason for Docker: consistent runtime, no local dependency issues, portable across environments.
. Reason for Flask: lightweight, fast to set up, good for small dashboards and APIs.
. Reason for Boto3: official AWS SDK for Python, handles authentication and API calls directly.
. Region set to us-east-1: common AWS default, easy to test with.

Steps in Dockerfile

. Base image: python:3.11-slim → small, secure, faster build times.
. ENV settings:

PYTHONDONTWRITEBYTECODE=1 → no .pyc files, cleaner container.

PYTHONNUMBUFFERED=1 → ensures logs flush immediately (important for Docker logs).
. Workdir: /app → keeps code organized inside container.
. Installed curl → useful for debugging network connectivity inside container.
. Copy requirements.txt first → allows Docker layer caching (faster builds if only code changes).
. Install dependencies with pip install --no-cache-dir → avoids unnecessary cache, keeps image smaller.
. Copy rest of project → ensures app code is inside container.
. CMD ["python", "main.py"] → starts the Flask app automatically.

Steps in main.py

. Fetch AWS credentials from environment → secure, no hardcoding.
. Create Boto3 session → used for EC2 + ELB clients.
. Flask route / → queries AWS for:

EC2 instances (ID, state, type, IP).

VPCs (ID, CIDR).

Load Balancers (Name, DNS).

AMIs owned by account (AMI ID, Name).
. Results rendered in simple HTML tables → easy to read from browser.
. App runs on host 0.0.0.0, port 5001 → accessible from outside container.

Requirements file

. Keeps dependencies tracked.
. Main ones: flask, boto3.
. Installed during Docker build so container is self-contained.

How to run

. Build image: docker build -t aws-dashboard .
. Run container (with AWS creds as env vars):
docker run -p 5001:5001 -e AWS_ACCESS_KEY_ID=xxx -e AWS_SECRET_ACCESS_KEY=yyy aws-dashboard
. Open in browser: http://localhost:5001
