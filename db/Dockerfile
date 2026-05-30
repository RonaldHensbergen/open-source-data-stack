FROM python:3.14-slim

RUN apt-get update && apt-get install -y gcc libpq-dev

COPY requirements.txt /tmp/requirements.txt

RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r /tmp/requirements.txt

COPY . /app

WORKDIR /app

CMD python3 scripts/create_db_insert_data.py
