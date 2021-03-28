# Create GKE cluster.
gcloud container clusters create cluster-1 --num-nodes=1 --machine-type=n1-standard-2

# Configure kubeconfig for the new cluster.
gcloud container clusters get-credentials cluster-1

# Add Airflow repo for Helm.
helm repo add airflow-stable https://airflow-helm.github.io/charts
helm repo update

# Install Airflow to the cluster.
helm install -f values.yaml airflow-1 airflow-stable/airflow

# Upgrade Airflow with new values or new version from repo.
# Note that breakthrough changes in values sometimes require to reinstall an app,
# e.g. after I changed CeleryExecutor to KubernetesExecutor.
helm upgrade -f values.yaml airflow-1 airflow-stable/airflow

# Get the pod name of Airflow Web for next commands.
POD_NAME=$(kubectl get pods --namespace default -l "component=web,app=airflow" -o jsonpath="{.items[0].metadata.name}")

# Login to Airflow Web where you can add or edit DAGs in
# 'dags' folder.
kubectl exec --stdin --tty $POD_NAME -- /bin/bash

# Map Airflow Web to localhost:8080
kubectl port-forward --namespace default $POD_NAME 8080:8080

# Uninstall Airflow.
helm uninstall airflow-1

# At the end delete the cluster.
gcloud container clusters delete cluster-1
