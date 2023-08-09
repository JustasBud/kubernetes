


# get endpoints (ports) - test if kubectl is set up correctly. Run 1_Setup_Kubectl_<cloud>.sh if not set up. 
# If connection timed out -  check firewall rules on k8 provider - whitelist IP for VM or set up VPC/Virtual Network
kubectl get endpoints






# INSTALL ArgoCD on k8 cluster
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml





# use Service Type Load Balancer, Ingress or Port Fw as below: # https://argo-cd.readthedocs.io/en/stable/getting_started/
kubectl port-forward svc/argocd-server -n argocd 8080:443 # add the following to enable remote access, otherwise localhost only --address='0.0.0.0'




argocd admin initial-password -n argocd #will print temp pw
argocd account update-password # to update pw


# set current namespace to argocd
kubectl config set-context --current --namespace=argocd



argocd login 127.0.0.1:8080


# Deploy project
kubectl apply -f https://raw.githubusercontent.com/JustasBud/kubernetes/main/argocd/projects/project-dev.yml

# Deploy app
argocd app create root-appbundle-app-dev --repo https://github.com/JustasBud/kubernetes.git --path argocd --dest-name in-cluster --dest-namespace default #use name or server, not both,
#  as defined in app definition --dest-server https://kubernetes.default.svc 

argocd app sync root-appbundle-app-dev

# deploy example app manually, if not using app-of-apps:
# argocd app create guestbook --repo https://github.com/JustasBud/kubernetes.git --path argocd/apps-children/dev/guestbook --dest-server https://kubernetes.default.svc --dest-namespace default
# argocd app sync guestbook



# Access kubernetes dashboard

kubectl proxy #only works on local machine
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/


#  use below for remote access:
kubectl port-forward -n kubernetes-dashboard service/kubernetes-dashboard 8443:443 --address 0.0.0.0
# Access dashboard via:
https://external.ip.address:8443



kubectl -n kubernetes-dashboard create token admin-user


# Access airflow
kubectl port-forward svc/airflow-stable-web -n airflow-stable  8055:8080
admin admin



################################################################## To Update Airflow (already in github) ##################################################################

helm repo add airflow-stable https://airflow-helm.github.io/charts
helm repo update
helm pull airflow-stable/airflow #--version 8.5.2
# extract above to local github repo for argocd to pick up and deploy




######################################################################################################################################################################################################
