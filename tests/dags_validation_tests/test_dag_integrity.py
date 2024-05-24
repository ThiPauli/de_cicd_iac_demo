import os

import pytest
from airflow.models import DagBag

# Define the path to the dags folder
DAGS_FOLDER = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "../../dags")
)

# Initialize the DagBag object
dag_bag = DagBag(dag_folder=DAGS_FOLDER, include_examples=False)


def get_dag_file_names():
    dag_files = []
    for root, _, files in os.walk(DAGS_FOLDER):
        for file in files:
            if file.endswith(".py"):
                dag_files.append(os.path.join(root, file))
    return dag_files


@pytest.mark.parametrize("dag_file", get_dag_file_names())
def test_dag_id_matches_file_name(dag_file):
    """
    test if a DAG ID is equal the filename
    """

    dag_id = os.path.basename(dag_file).replace(".py", "")
    assert (
        dag_id in dag_bag.dags
    ), f"DAG ID '{dag_id}' not found in DagBag for file '{dag_file}'"

    dag = dag_bag.get_dag(dag_id)
    assert (
        dag.dag_id == dag_id
    ), f"DAG ID '{dag.dag_id}' does not match file name '{dag_file}'"


@pytest.mark.parametrize("dag_id", dag_bag.dag_ids)
def test_dag_has_specific_tags(dag_id):
    """
    test if a DAG has TAGs as defined  in the required tags
    """
    required_tags = {"etl", "demo-cicd"}

    dag = dag_bag.get_dag(dag_id)
    dag_tags = set(dag.tags)
    missing_tags = required_tags - dag_tags
    assert not missing_tags, f"DAG '{dag_id}' is missing tags: {missing_tags}"


def test_no_import_errors():
    assert (
        len(dag_bag.import_errors) == 0
    ), f"Total import failures: {len(dag_bag.import_errors)}"
