from pendulum import datetime
from datetime import timedelta

from airflow.sdk import dag, task

DAG_ID = "project_level_dbt_dag"
DAG_OWNER = "ronaldhensbergen"

DBT_PROJECT_PATH = "/opt/dbt/jaffle_shop"

default_args = {
    "owner": DAG_OWNER,
    "retries": 3,
    "retry_delay": timedelta(minutes=2),
}
@dag(dag_id=DAG_ID,
     schedule=None,
     start_date=datetime(2023, 1, 1, tz="UTC"),
     default_args=default_args,
     description="An Airflow DAG to invoke simple dbt commands",
     catchup=False)

def project_level_dbt_dag():        

    @task.bash
    def dbt_run_command()-> str:
        return f"""
            dbt run --profiles-dir {DBT_PROJECT_PATH} --project-dir {DBT_PROJECT_PATH}
            """

    @task.bash
    def dbt_test_command()-> str:
        return f"""
            dbt test --profiles-dir {DBT_PROJECT_PATH} --project-dir {DBT_PROJECT_PATH} --vars '{{"date": " {{{{ ds }}}} " }}'
            """
            


        dbt_run = dbt_run_command()

        dbt_test = dbt_test_command()

        dbt_run >> dbt_test
project_level_dbt_dag = project_level_dbt_dag()