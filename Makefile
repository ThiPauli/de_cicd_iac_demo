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

####################################################################################################################
# Set up cloud infrastructure with Terraform

tf-init:
	terraform -chdir=./terraform init

tf-format:
	terraform -chdir=./terraform fmt -recursive

infra-up:
	terraform -chdir=./terraform apply

infra-down:
	terraform -chdir=./terraform destroy

infra-config:
	terraform -chdir=./terraform output

# Helper command to connect via SSH into the EC2 instance provisioned by Terraform
ssh-ec2:
	terraform -chdir=./terraform output -raw private_key > private_key.pem && chmod 600 private_key.pem && ssh -o StrictHostKeyChecking=no -o IdentitiesOnly=yes -i private_key.pem ubuntu@$$(terraform -chdir=./terraform output -raw public_dns) && rm private_key.pem

# Helper command to print out the private_key content from the EC2 instance
privatekey-ec2:
	terraform -chdir=./terraform output -raw private_key
