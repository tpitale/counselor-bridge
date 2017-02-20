build:
	docker build -t advocate-bridge .

tag:
	docker tag advocate-bridge:latest ${DOCKER_REGISTRY}/advocate-bridge

push:
	docker push ${DOCKER_REGISTRY}/advocate-bridge

release: build tag push

run: build
	docker run -it -p 3001:80 --env-file .env --rm --name advocate-bridge advocate-bridge

console: build
	docker run -it -p 3000:80 --env-file .env --rm --name advocate-bridge advocate-bridge iex -S mix

shell:
	docker exec -it advocate-bridge /bin/bash
