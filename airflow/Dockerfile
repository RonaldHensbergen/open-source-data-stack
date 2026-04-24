ARG DOCKER_IMAGE_AIRFLOW=x
FROM ${DOCKER_IMAGE_AIRFLOW}

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


RUN pip install --no-cache-dir \
#    --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-3.2.0/constraints-3.12.txt" \
    -r /tmp/requirements.txt

#RUN python -c "import importlib, sys; sys.exit(0 if importlib.util.find_spec('airflow-operators') else 1)"
