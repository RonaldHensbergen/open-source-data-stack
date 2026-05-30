FROM python:3.14-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc \
        libpq-dev \
        python3-dev && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt /tmp/requirements.txt

RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r /tmp/requirements.txt \
    && pip cache purge
# Optional: copy your dbt project & profiles (read‑only)
COPY jaffle_shop/ /opt/dbt/jaffle_shop/
COPY profiles.yml /opt/dbt/jaffle_shop/profiles.yml

WORKDIR /opt/dbt/jaffle_shop

#ENTRYPOINT ["dbt"]
