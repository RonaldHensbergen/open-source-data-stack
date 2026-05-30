ARG DOCKER_IMAGE_AIRFLOW=x
FROM apache/airflow:3.2.2-python3.12

USER root

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    python3-dev \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER airflow

# Install Python dependencies
COPY requirements.txt /tmp/requirements.txt


RUN pip install --upgrade pip \
    && pip install --no-cache-dir \
    -r /tmp/requirements.txt
