####################################################################################################################
# Setup containers to run Airflow

docker-spin-up:
	docker compose --env-file .env up airflow-init && docker compose --env-file .env up --build -d

# Create necessary directories and adjust permissions in the host environment
set-host-perms:
	sudo mkdir -p logs plugins dags tests && sudo chmod -R u+rwx,g+rwx,o+rwx logs plugins dags tests

up: set-host-perms docker-spin-up

down:
	docker compose down

sh:
	docker exec -ti airflow-webserver bash

####################################################################################################################
# Testing, format checks, type checks, & Lint checks

# It will test code to verify that behaves as expected
pytest:
	docker exec airflow-webserver pytest -p no:warnings -v /opt/airflow/tests

# # It will check the code formatting
# format:
# 	docker exec airflow-webserver python -m black --check -S --line-length 79 .

# # It will check the import order
# isort:
# 	docker exec airflow-webserver isort --check-only --profile black .

# It will check for type issues
type:
	docker exec airflow-webserver mypy --ignore-missing-imports /opt/airflow

# It will check for coding style issue
lint:
	docker exec airflow-webserver flake8 --ignore=E501 /opt/airflow/dags

ci: type lint pytest
