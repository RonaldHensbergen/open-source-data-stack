FROM python:3.12-slim

RUN apt-get update && apt-get install -y gcc libpq-dev

COPY . /app

WORKDIR /app

COPY requirements.txt /tmp/requirements.txt

RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r /tmp/requirements.txt


CMD python3 db/scripts/create_db_insert_data.py
