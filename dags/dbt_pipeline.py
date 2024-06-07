from datetime import datetime, timedelta

from cosmos import DbtDag, ProfileConfig, ProjectConfig
from cosmos.profiles import DatabricksTokenProfileMapping

DBT_PROJECT_PATH = "/opt/airflow/dbt/tp_dbt"  # dbt path as mapped in Airflow container volumes

profile_config = ProfileConfig(
    profile_name="tp_dbt",
    target_name="dev",
    profile_mapping=DatabricksTokenProfileMapping(
        conn_id="databricks_default",
        profile_args={"schema": "tp_schema"},
        disable_event_tracking=True,
    ),
)

dbt_pipeline = DbtDag(
    # dbt/cosmos-specific parameters
    project_config=ProjectConfig(
        dbt_project_path=DBT_PROJECT_PATH,
    ),
    profile_config=profile_config,
    operator_args={
        "install_deps": True,  # install any necessary dependencies before running any dbt command
        "full_refresh": True,  # used only in dbt commands that support this flag
    },
    # dag parameters
    schedule_interval=None,
    start_date=datetime(2023, 1, 1),
    dag_id="dbt_pipeline",
    default_args={
        "owner": "tp",
        "retries": 1,
        "retry_delay": timedelta(minutes=1),
    },
    tags=["etl", "demo-cicd", "dbt", "databricks"],
)
