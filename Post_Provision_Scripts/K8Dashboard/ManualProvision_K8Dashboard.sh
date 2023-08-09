





# Install kubernetes dashboard (without ArgoCD)
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml


# Access kubernetes api server (will not work on remote even with --address 0.0.0.0 specified, as per docs (due to security), but to investigate further)
# kubectl proxy
# Access via API server directly, but for local access only:
# http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/



# Create Service Account and ClusterRoleBinding
kubectl apply -f https://raw.githubusercontent.com/JustasBud/kubernetes/main/Post_Provision_Scripts/K8Dashboard/dashboard-adminuser.yaml

# Get admin-user token
kubectl -n kubernetes-dashboard create token admin-user



kubectl port-forward -n kubernetes-dashboard service/kubernetes-dashboard 8443:443 --address 0.0.0.0

# Access DB via:
https://external.ip.address:8443













