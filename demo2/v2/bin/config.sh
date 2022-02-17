kubectl create secret generic db-secret --from-literal=username=root --from-literal=password=Welcome1!
kubectl apply -f webquerydb-cfg.yaml


