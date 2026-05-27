#!/bin/bash
BACKUP_DIR="./backups"

docker compose exec -T superset-db pg_dump -U superset -Fc superset \
  > $BACKUP_DIR/backup_superset_$(date +%Y%m%d_%H%M%S).dump

# Keep only last 7 backups
ls -t $BACKUP_DIR/backup_superset_*.dump | tail -n +8 | xargs rm -f
