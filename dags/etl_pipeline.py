from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.trigger_dagrun import TriggerDagRunOperator

default_args = {
    "owner": "tp",
    "depends_on_past": False,
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=1),
}

with DAG(
    dag_id="etl_pipeline",
    default_args=default_args,
    description="A master DAG to orchestrate the data ingestion from API and the SQL transormations developed in dbt core",
    schedule_interval=None,
    start_date=datetime(2023, 1, 1),
    tags=["etl", "demo-cicd", "api", "dbt", "orchestration"],
) as dag:

    # Task to trigger the jsonplaceholder_api_data DAG
    trigger_jsonplaceholder_api_data = TriggerDagRunOperator(
        task_id="trigger_jsonplaceholder_api_data",
        trigger_dag_id="jsonplaceholder_api_data",
        wait_for_completion=True,
        poke_interval=1,
    )

    # Task to trigger the dbt_pipeline DAG
    trigger_dbt_pipeline = TriggerDagRunOperator(
        task_id="trigger_dbt_pipeline",
        trigger_dag_id="dbt_pipeline",
        wait_for_completion=True,
        poke_interval=1,
    )

    # Set the dependencies
    trigger_jsonplaceholder_api_data >> trigger_dbt_pipeline
