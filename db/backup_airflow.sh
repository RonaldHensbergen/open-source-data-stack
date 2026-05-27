#!/bin/bash
BACKUP_DIR="./backups"

docker compose exec -T postgres pg_dump -U airflow -Fc airflow \
  > $BACKUP_DIR/backup_airflow_$(date +%Y%m%d_%H%M%S).dump

# Keep only last 7 backups
ls -t $BACKUP_DIR/backup_airflow_*.dump | tail -n +8 | xargs rm -f


