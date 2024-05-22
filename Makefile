####################################################################################################################
# Setup containers to run Airflow

docker-spin-up:
	docker compose --env-file .env up airflow-init && docker compose --env-file .env up --build -d

up: docker-spin-up

down:
	docker compose down

sh:
	docker exec -ti webserver bash