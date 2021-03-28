import os

from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.utils.dates import days_ago


def print_stuff():
    print('HELLO FROM AIRFLOW')


args = {
    'owner': 'airflow',
}

with DAG(
    dag_id='example_kubernetes_executor',
    default_args=args,
    schedule_interval='@once',
    start_date=days_ago(2),
    tags=['example', 'example2'],
) as dag:

    # You don't have to use any special KubernetesExecutor configuration if you don't want to
    start_task = PythonOperator(task_id='start_task', python_callable=print_stuff)
