import os

from airflow import DAG
from airflow.providers.cncf.kubernetes.operators.kubernetes_pod import KubernetesPodOperator
from airflow.utils.dates import days_ago


args = {
    'owner': 'airflow',
}

with DAG(
    dag_id='example_kubernetes_pod',
    default_args=args,
    schedule_interval='@once',
    start_date=days_ago(1),
    tags=['example', 'example2'],
) as dag:

    KubernetesPodOperator(
        namespace='default',
        image='alpine',
        cmds=['sh', '-c', 'echo HELLO FROM AIRFLOW'],
        name='pod-example',
        is_delete_operator_pod=True,
        in_cluster=True,
        task_id='pod-example',
        get_logs=True,
    )
