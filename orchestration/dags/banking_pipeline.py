from airflow import DAG
from airflow.providers.snowflake.operators.snowflake import SnowflakeOperator
from airflow.operators.bash import BashOperator
from datetime import datetime

default_args = {
    'owner': 'airflow',
    'start_date': datetime(2026, 6, 20),
}

with DAG('banking_s3_to_marts', default_args=default_args, schedule_interval='@hourly', catchup=False) as dag:

    # Dynamic S3 Path Pruning
    dynamic_s3_path = "raw_banking_data/year={{ execution_date.year }}/month={{ execution_date.strftime('%m') }}/day={{ execution_date.strftime('%d') }}/"

    load_raw = SnowflakeOperator(
        task_id='copy_into_raw',
        snowflake_conn_id='snowflake_conn',
        sql=f"""
        COPY INTO BANKING_DWH.RAW.raw_transactions (raw_data)
        FROM @BANKING_DWH.RAW.raw_stage/{dynamic_s3_path}
        FILE_FORMAT = (TYPE = JSON)
        ON_ERROR = 'CONTINUE';
        """
    )

    dbt_run = BashOperator(
        task_id='dbt_run_marts',
        bash_command='cd /opt/airflow/dbt_transformations && dbt run --profiles-dir /opt/airflow/dbt_transformations'
    )

    load_raw >> dbt_run