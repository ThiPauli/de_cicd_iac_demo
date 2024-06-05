import json
import os
from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.amazon.aws.hooks.s3 import S3Hook
from dotenv import load_dotenv

from include.utils import (
    get_jsonplaceholder_comments_api,
    get_jsonplaceholder_posts_api,
)

# Load environment variables from .env file
load_dotenv()

# Get the S3 bucket name from environment variables
S3_BUCKET_NAME = os.getenv("TP_BUCKET_NAME")


def save_to_s3(data, key):
    s3_hook = S3Hook(aws_conn_id="aws_default")
    s3_hook.load_string(
        string_data=json.dumps(data),
        key=key,
        bucket_name=S3_BUCKET_NAME,
        replace=True,
    )


def fetch_and_store_posts():
    posts = get_jsonplaceholder_posts_api()
    save_to_s3(posts, "raw/posts/posts.json")


def fetch_and_store_comments():
    comments = get_jsonplaceholder_comments_api()
    save_to_s3(comments, "raw/comments/comments.json")


# Define the default_args dictionary. These args will be passed to each operator.
default_args = {
    "owner": "tp",
    "depends_on_past": False,
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=1),
}

dag = DAG(
    "jsonplaceholder_api_data",
    default_args=default_args,
    description="Fetch data from JSONPlaceholder API endpoints and store in S3",
    schedule_interval=None,
    start_date=datetime(2023, 1, 1),
    tags=["etl", "demo-cicd", "api", "S3"],
)

fetch_posts_task = PythonOperator(
    task_id="fetch_and_store_posts",
    python_callable=fetch_and_store_posts,
    dag=dag,
)

fetch_comments_task = PythonOperator(
    task_id="fetch_and_store_comments",
    python_callable=fetch_and_store_comments,
    dag=dag,
)

fetch_posts_task >> fetch_comments_task
