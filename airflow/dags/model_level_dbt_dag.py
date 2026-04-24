from pendulum import datetime   
from datetime import timedelta

from airflow.providers.standard.operators.empty import EmptyOperator
from airflow.utils.task_group import TaskGroup

from dbt_dag_parser_v2 import DbtDagParser
from airflow.sdk import dag, task

DAG_ID = "model_level_dbt_dag"
DAG_OWNER = "ronaldhensbergen"

DBT_PROJECT_PATH = "/opt/dbt/jaffle_shop"
DBT_GLOBAL_CLI_FLAGS = "--no-write-json"
DBT_TARGET = "dev"

default_args = {
    "owner": DAG_OWNER,
    "retries": 3,
    "retry_delay": timedelta(minutes=2),
}
@dag(dag_id=DAG_ID,
     schedule=None, 
     start_date=datetime(2023, 1, 1, tz="UTC"), 
     default_args=default_args,
     description="A dbt wrapper for Airflow using a utility class to map the dbt DAG to Airflow tasks",
     catchup=False)

def model_level_dbt_dag():

    @task.bash
    def dbt_debug_command()-> str:
        return f"""
            dbt debug --profiles-dir {DBT_PROJECT_PATH} --project-dir {DBT_PROJECT_PATH}
            """
    dbt_debug = dbt_debug_command()

    @task.bash
    def dbt_parse_command()-> str:
        return f"""
            dbt parse --profiles-dir {DBT_PROJECT_PATH} --project-dir {DBT_PROJECT_PATH}
            """
    dbt_parse = dbt_parse_command()

    @task.bash
    def dbt_compile_command()-> str:
        return f"""
            dbt compile --profiles-dir {DBT_PROJECT_PATH} --project-dir {DBT_PROJECT_PATH} --vars '{{"date": " {{{{ ds }}}} " }}'
            """
    dbt_compile = dbt_compile_command()

    # Define EmptyOperator
    start_dummy = EmptyOperator(task_id="start")
    end_dummy = EmptyOperator(task_id="end")
    start_run_dbt_dummy = EmptyOperator(task_id="start_run_dbt")
    start_test_dbt_dummy = EmptyOperator(task_id="start_test_dbt")

    # Validate taskgroups
    validate_taskgroup = TaskGroup("dbt_validate")


    start_dummy >> dbt_debug >> dbt_parse >> dbt_compile >> start_run_dbt_dummy

    # The parser parses out a dbt manifest.json file and dynamically creates tasks for "dbt run" and "dbt test"
    # commands for each individual model. It groups them into task groups which we can retrieve and use in the DAG.
    dag_parser = DbtDagParser(
        dbt_global_cli_flags=DBT_GLOBAL_CLI_FLAGS,
        dbt_project_dir=DBT_PROJECT_PATH,
        dbt_profiles_dir=DBT_PROJECT_PATH,
        dbt_target=DBT_TARGET,
    )
    
    dbt_run_group = dag_parser.get_dbt_run_group()
    dbt_test_group = dag_parser.get_dbt_test_group()

    start_run_dbt_dummy >> dbt_run_group >> start_test_dbt_dummy >> dbt_test_group

 
    @task.bash
    def dbt_docs_command()-> str:
        return f"""
            dbt docs generate --profiles-dir {DBT_PROJECT_PATH} --project-dir {DBT_PROJECT_PATH} --vars '{{"date": " {{{{ ds }}}} " }}'
            """
    dbt_docs = dbt_docs_command()
   
    dbt_test_group >> dbt_docs >> end_dummy
model_level_dbt_dag = model_level_dbt_dag()