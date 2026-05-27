$bash
docker network create open-source-data-stack
docker compose -f docker-compose.yml build
docker compose -f docker-compose.yml -f docker-compose-superset.yml up -d
