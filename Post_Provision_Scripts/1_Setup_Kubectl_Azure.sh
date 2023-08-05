# connect kubectl to k8 aks:
az login

az aks get-credentials \
  --resource-group xxxxxx-rg \
  --name mycluster \
  --subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx



# get endpoints (ports) - test if kubectl is configured properly
kubectl get endpoints




