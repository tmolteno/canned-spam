DOCKER=/usr/bin/docker
COMPOSE=/usr/bin/docker compose --progress plain
USER=tart

build:
	${COMPOSE} --parallel 1 -f docker-compose.yml build

