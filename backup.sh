#!/bin/bash

COMPOSE_FILE=docker-compose.yml
BACKUP_DIR=$HOME/mc-backups
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/world-$DATE.tar.gz"

mkdir -p $BACKUP_DIR

echo "Starting backup: $DATE"

docker compose -f $COMPOSE_FILE stop mc

if [ $? -eq 0 ]; then
	echo "Server stopped successfully"
else
	echo "Failed to stop server"
	exit 1
fi

docker run --rm \
	--user root \
	-v minecraft-server-docker_mc-data:/data \
	-v $BACKUP_DIR:/backup:z \
	ubuntu tar czf /backup/world-$DATE.tag.gz /data/world
if [ $? -eq 0 ]; then
	echo "Backup saved: $BACKUP_FILE"
else
	echo "Backup failed"
	docker compose -f $COMPOSE_FILE start mc
	exit 1
fi

docker compose -f $COMPOSE_FILE start mc

echo "Done. Server is back online."
