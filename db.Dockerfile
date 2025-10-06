FROM python:3.9-slim

RUN apt-get update && apt-get install -y gcc libpq-dev

COPY . /app

WORKDIR /app

RUN pip install --upgrade pip
RUN pip install pandas==1.3.5
RUN pip install psycopg2-binary==2.9.9

CMD python3 db/scripts/create_db_insert_data.py
