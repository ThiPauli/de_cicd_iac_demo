from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.python_operator import PythonOperator

# Define the default_args dictionary. These args will be passed to each operator.
default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}


# Define a simple function that will be run by the PythonOperator
def print_hello():
    print("Hello World")


def print_goodbye():
    print("Goodbye World")


# Create the DAG
dag = DAG(
    "test_dag_ci_pass",
    default_args=default_args,
    description="A simple DAG",
    schedule_interval=None,
    start_date=datetime(2023, 1, 1),
    catchup=False,
    tags=["etl", "demo-cicd"],
)

# Define the tasks
task1 = PythonOperator(
    task_id="print_hello",
    python_callable=print_hello,
    dag=dag,
)

task2 = PythonOperator(
    task_id="print_goodbye",
    python_callable=print_goodbye,
    dag=dag,
)

# Set the task dependencies
task1 >> task2
