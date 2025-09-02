FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONNUMBUFFERED=1


WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl \ && rm -rf /varlib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cach-dir -r requirements.txt 

COPY . .

EXPOSE 5001

CMD ["python", "main.py" ]