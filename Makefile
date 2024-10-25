DOCKER=/usr/bin/docker
COMPOSE=/usr/bin/docker compose --progress plain
USER=tart

build:
	${COMPOSE} --parallel 1 -f docker-compose.yml build

run:	build
	${COMPOSE} --parallel 1 -f docker-compose.yml run --rm spam

# Huge download ~600 MB
get:
	cd files; sh get_files.sh
