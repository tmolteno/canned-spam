DOCKER=/usr/bin/docker
COMPOSE=/usr/bin/docker compose --progress plain

run:
	HOST_UID=$(shell id -u) HOST_GID=$(shell id -g) ${COMPOSE} --parallel 1 -f docker-compose.yml run --rm spam

docker_build:
	docker build --build-arg UID=$(shell id -u) --build-arg GID=$(shell id -g) --tag spam_image .

docker_run:
	docker run --workdir /spam_store --user $(shell id -u):$(shell id -g) -i -t -v ~/spam_store:/spam_store spam_image

build:
	HOST_UID=$(shell id -u) HOST_GID=$(shell id -g) ${COMPOSE} --parallel 1 -f docker-compose.yml build

# Huge download ~600 MB
get:
	cd files; sh get_files.sh
