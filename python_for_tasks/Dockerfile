FROM python:3.12-slim

RUN apt-get update && apt-get install -y gcc libpq-dev

COPY requirements.txt /tmp/requirements.txt

RUN pip install --upgrade pip \
    && pip install --no-cache-dir \
    -r /tmp/requirements.txt \
    && rm -rf /tmp/requirements.txt

COPY . /app

WORKDIR /app
