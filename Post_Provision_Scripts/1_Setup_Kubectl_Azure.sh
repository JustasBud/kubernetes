# connect kubectl to k8 aks:
az login

az aks get-credentials --resource-group xxxxxx-rg --name mycluster --subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx



# get endpoints (ports) - test if kubectl is set up correctly.
# If connection timed out -  check firewall rules on k8 provider - whitelist IP for VM or set up VPC/Virtual Network
kubectl get endpoints




