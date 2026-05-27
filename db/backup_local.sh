#!/bin/bash
BACKUP_DIR="./backups"

docker compose exec -T postgres-local pg_dump -U docker -Fc raw \
  > $BACKUP_DIR/backup_local_$(date +%Y%m%d_%H%M%S).dump

# Keep only last 7 backups
ls -t $BACKUP_DIR/backup_local_*.dump | tail -n +8 | xargs rm -f
