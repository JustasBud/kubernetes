# connect kubectl to k8 aks:
az login

az aks get-credentials --resource-group xxxxxx-rg --name mycluster --subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx



# get endpoints (ports) - test if kubectl is set up correctly.
# If connection timed out -  check firewall rules on k8 provider - whitelist IP for VM or set up VPC/Virtual Network
kubectl get endpoints


# Create PW for Ubuntu RDP sessions:
# If you created a password for your user account when you created your VM, skip this step. 
# If you only use SSH key authentication and don't have a local account password set, specify a password before you use xrdp to log in to your VM.
sudo passwd azureuser