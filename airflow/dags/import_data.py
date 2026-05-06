from __future__ import annotations

import logging
import time
import pandas as pd

import pendulum

from airflow.sdk import dag, task

log = logging.getLogger(__name__)

@dag(
    schedule=None,
    start_date=pendulum.datetime(2021, 1, 1, tz="UTC"),
    catchup=False,
    tags=["example"],
)

def import_and_save_data():
    @task()
    def import_data_task():
        log.info("Importing data...")
        df = pd.read_csv("/opt/airflow/data/test.txt")
        log.info("Data imported successfully!")
        return df
    import_data_task()

    @task
    def save_data_task(df):
        log.info("Saving data...")
        df.to_csv("/opt/airflow/data/output.csv", index=False)
        log.info("Data saved successfully!")

    save_data_task(import_data_task())

dag = import_and_save_data()
