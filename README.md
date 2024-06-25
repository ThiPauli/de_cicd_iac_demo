# Demo data project with IAC, CI/CD, testing and data manipulation with Terraform, Python, AWS, Airflow, DBT, and Databricks

## Table of Contents
- [Introduction](#introduction)
- [Project Structure](#project-structure)
- [Tools and Technologies](#tools-and-technologies)
- [Infrastructure Setup](#infrastructure-setup)
- [CI/CD Pipelines](#cicd-pipelines)
- [Data Ingestion](#data-ingestion)
- [Data Transformation](#data-transformation)
- [Data Orchestration](#data-orchestration)
- [Running the Project](#running-the-project)
- [Testing](#testing)
- [Documentation](#documentation)

## Introduction
This project demonstrates a comprehensive data pipeline using Infrastructure as Code (IaC) with Terraform, CI/CD pipelines with GitHub Actions, and various tools for data transformation and orchestration. The project provisions infrastructure on AWS, orchestrates workflows with Airflow, performs data transformations with dbt Core, and uses Docker for containerization.

## Project Structure
```
├── dags/
│   ├── dbt_pipeline.py
│   ├── etl_pipeline.py
│   └── jsonplaceholder_api_data.py
├── containers/
│   └── airflow/
│       ├── Dockerfile
│       └── requirements.txt
├── dbt/
│   └── tp_dbt/
│       ├── models/
│       │   ├── staging/
│       │   ├── marts/
│       │   └── views/
│       └── dbt_project.yml
├── tests/
│   ├── dags_validation_tests/
│   └── integration_tests/
├── include/
│   └── utils.py
├── .github/
│   ├── workflows/
│   │   ├── ci.yaml
│   │   ├── cd.yaml
│   │   └── deploy_dbt_docs.yml
├── terraform/
│   ├── ec2_instance/
│   ├── network/
│   ├── s3_bucket/
│   ├── main.tf
│   └── variables.tf
├── Makefile
├── docker-compose.yaml
└── README.md
```

## Tools and Technologies
- **Docker & Docker Compose**: For running Airflow.
- **Terraform**: To provision infrastructure on AWS.
- **Airflow**: For orchestrating workflows.
- **dbt Core**: For data transformation.
- **Databricks**: As the data warehouse.
- **Pytest & Pydantic**: For testing and data validation.
- **GitHub Actions**: For CI/CD pipelines.

## Infrastructure Setup
The infrastructure is provisioned using Terraform and includes:
1. **Network Setup**:
   - VPC, Subnet, Internet Gateway, Route Table, and Association.
2. **Compute Resources**:
   - EC2 instance to run Docker and Airflow, with appropriate security groups and SSH access.
3. **Storage**:
   - S3 bucket to store data ingested from APIs.

## CI/CD Pipelines
### Continuous Integration (CI)
- **Trigger**: New pull request to the main branch.
- **Steps**:
   1. Clone the repository.
   2. Spin up Docker containers with Airflow.
   3. Run tests (type, lint, and pytest).

### Continuous Deployment (CD)
- **Trigger**: New artifacts in the main branch.
- **Steps**:
   1. Clone the repository.
   2. Deploy code to the EC2 instance.
   3. Rebuild Docker containers to apply changes.

## Data Ingestion
Make API requests from [JSONPlaceholder](https://jsonplaceholder.typicode.com/) using `utils.py` to pull sample data and save the response to the AWS S3 bucket.

## Data Transformation
### dbt Core with Databricks
- **Staging Models**: Read data from S3 and persist in the Hive metastore.
- **Views**: Join staging tables.
- **Marts**: Aggregated metrics and summaries.

## Data Orchestration
### Orchestration with Airflow
Airflow DAGs manage:
1. Data ingestion from APIs (require AWS connection) - DAG: `jsonplaceholder_api_data.py`
2. Data transformation with dbt models using Astronomer Cosmos (require Databricks connection) - DAG: `dbt_pipeline.py`

![airflow_dbt_pipeline](https://github.com/ThiPauli/de_cicd_iac_demo/blob/main/images/airflow_dbt_pipeline.png)

## Running the Project

### Prerequisites
1. **Git**: Ensure git is installed on your machine.
2. **Docker**: Install Docker with at least 4GB of RAM and Docker Compose v1.27.0 or later.
3. **AWS CLI**: Install and configure AWS CLI with credentials set at `~/.aws/credentials`.
4. **Terraform**: Ensure Terraform is installed.
5. **dbt**: Install dbt with credentials set at `~/.dbt/profiles.yml`.
6. **Airflow Connections**: Create Airflow connections (Databricks and AWS) using the Airflow UI to run the DAG.

### Steps to Run the Project
1. **Clone the Repository**:
   ```sh
   git clone https://github.com/ThiPauli/de_cicd_iac_demo.git
   cd de_cicd_iac_demo
   ```
2. **Provision Infrastructure**:
   ```sh
   make tf-init
   make infra-up
   ```
3. **Start Airflow**:
   ```sh
   make up
   make ci # run checks and tests
   ```
4. **Run dbt Models (optional)**:
   ```sh
   make dbt-run
   ```
4. **Run Airflow DAGs from UI**:
   Run `etl_pipeline.py` which ingest data from API and store on AWS S3, and run dbt models.

## Testing
### Unit Tests
- Validate DAG integrity regarding ID, tags and checking import errors using Pytest.
### Integration Tests
- Use Pytest and Pydantic to validate API responses against expected data schemas.

## Documentation
The dbt project documentation provides an overview of the project's resources such as models, tests, and metrics. It includes metadata and lineage information to help you understand the latest production state of the data pipeline. The documentation is deployed on GitHub Pages using GitHub Actions with `deploy_dbt_docs.yml` and is available at: [dbt Project Documentation](https://thipauli.github.io/de_cicd_iac_demo/)
