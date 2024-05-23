####################################################################################################################
# Setup containers to run Airflow

docker-spin-up:
	docker compose --env-file .env up airflow-init && docker compose --env-file .env up --build -d

# Adjust permissions for the relevant directories
perms:
	docker exec airflow-webserver sudo chmod -R u+rwx,g+rwx,o+rwx /opt/airflow/tests /opt/airflow/logs /opt/airflow/plugins /opt/airflow/dags

up: docker-spin-up perms

down:
	docker compose down

sh:
	docker exec -ti airflow-webserver bash

####################################################################################################################
# Testing, auto formatting, type checks, & Lint checks

# It will test code to verify that behaves as expected
pytest:
	docker exec airflow-webserver pytest -p no:warnings -v /opt/airflow/tests

# It will modify the files if necessary to correct code formatting
format:
	docker exec airflow-webserver python -m black -S --line-length 79 .

# It will modify the files if necessary to correct import order
isort:
	docker exec airflow-webserver isort .

# It will check for type issues
type:
	docker exec airflow-webserver mypy --ignore-missing-imports /opt/airflow

# It will check for coding style issue
lint: 
	docker exec airflow-webserver flake8 /opt/airflow/dags

ci: isort format type lint pytest