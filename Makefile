
PROJECT_NAME := "openresty-app"

build:
	docker build -t $(PROJECT_NAME) .

run:
	@docker run \
		--name $(PROJECT_NAME) \
		-p 8080:8080 \
		--rm \
		-it $(PROJECT_NAME)

# TODO: make this run within docker automatically. Currently is used by running
# docker exec -i --tty openwestopenrestyworkshop_app_1 /bin/bash after running
# `docker-compose up
lint:
	luacheck src src/lua/*.lua

attach:
	@docker exec \
		--interactive \
		--tty $(PROJECT_NAME) \
		/bin/bash

