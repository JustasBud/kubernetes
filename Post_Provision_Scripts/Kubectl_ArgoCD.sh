


# get endpoints (ports) - test if kubectl is set up correctly. Run 1_Setup_Kubectl_<cloud>.sh if not set up. 
# If connection timed out -  check firewall rules on k8 provider - whitelist IP for VM or set up VPC/Virtual Network
kubectl get endpoints






# INSTALL ArgoCD on k8 cluster
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml





# use Service Type Load Balancer, Ingress or Port Fw as below: # https://argo-cd.readthedocs.io/en/stable/getting_started/
kubectl port-forward svc/argocd-server -n argocd 8080:443



argocd admin initial-password -n argocd #will print temp pw
argocd account update-password # to update pw


# set current namespace to argocd
kubectl config set-context --current --namespace=argocd


argocd app create root-appbundle-app-dev --repo https://github.com/JustasBud/kubernetes.git --path argocd --dest-server https://kubernetes.default.svc --dest-namespace default
argocd app sync root-appbundle-app-dev

# deploy example app manually, if not using app-of-apps:
# argocd app create guestbook --repo https://github.com/JustasBud/kubernetes.git --path argocd/apps-children/dev/guestbook --dest-server https://kubernetes.default.svc --dest-namespace default
# argocd app sync guestbook



# Access kubernetes dashboard

kubectl proxy
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/


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