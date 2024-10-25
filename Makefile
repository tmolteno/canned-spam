DOCKER=/usr/bin/docker
COMPOSE=/usr/bin/docker compose --progress plain

run:
	CURRENT_UID=$(id -u):$(id -g) ${COMPOSE} --parallel 1 -f docker-compose.yml run --rm spam

docker_build:
	docker build --tag spam_image .

docker_run:
	docker run -i -t -v ~/spam_store:/spam_store spam_image

build:
	${COMPOSE} --parallel 1 -f docker-compose.yml build

# Huge download ~600 MB
get:
	cd files; sh get_files.sh
