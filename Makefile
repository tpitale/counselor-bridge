build:
	docker build --build-arg BUILD_ENV=${BUILD_ENV} -t advocate-bridge_${BUILD_ENV} .

tag:
	docker tag advocate-bridge_${BUILD_ENV}:latest ${DOCKER_REGISTRY}/advocate-bridge_${BUILD_ENV}

push:
	docker push ${DOCKER_REGISTRY}/advocate-bridge_${BUILD_ENV}

release: build tag push

run: build
	docker run -it -p 3001:80 --env-file .env --rm --name advocate-bridge advocate-bridge_${BUILD_ENV}

console: build
	docker run -it -p 3000:80 --env-file .env --rm --name advocate-bridge advocate-bridge_${BUILD_ENV} iex --sname advocate-bridge-console --cookie ${COOKIE} -S mix

shell:
	docker exec -it advocate-bridge /bin/bash
