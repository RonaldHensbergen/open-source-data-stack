FROM apache/airflow:2.7.0-python3.9

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
RUN pip install --upgrade pip \
    && pip install dbt-postgres==1.9.1 \
    && pip install airflow-provider-great-expectations>=0.3.0 \
    && pip install great_expectations==1.6.4
