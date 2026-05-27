$bash
docker compose -f docker-compose.yml -f docker-compose-superset.yml down
docker volume prune -f
docker network rm open-source-data-stack