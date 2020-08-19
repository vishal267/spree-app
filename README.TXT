Infra launching 

cd k8s/terraform-eks
terraform init  
terraform plan
terraform apply

terraform output kubeconfig>~/.kube/config


K8s Networking and Launching infa

#Calico Networking 

kubectl apply -f https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/release-1.5/config/v1.5/calico.yaml

kubectl get ds -n kube-system | grep -i 'calico-node'

#Helm Tiller 

helm init

kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'


#Nginx Ingress Controller 

helm install \
stable/nginx-ingress \
--name my-nginx \
--set rbac.create=true

helm status my-nginx 


#K8s Dashboard 

helm install --namespace kube-system stable/kubernetes-dashboard --name k8s-dashboard  -f values.yaml


Monitoring stack 

#prometheus using Persistent Volume 
kubectl create namespace prometheus

helm install --name prometheus stable/prometheus \
    --namespace prometheus \
    --set alertmanager.persistentVolume.storageClass="gp2" \
    --set server.persistentVolume.storageClass="gp2"

kubectl get all -n prometheus

kubectl port-forward -n prometheus deploy/prometheus-server 8080:9090


#Grafana using persistent Volume 

kubectl create namespace grafana
helm install --name grafana stable/grafana \
    --namespace grafana \
    --set persistence.storageClassName="gp2" \
    --set adminPassword='EKS!sAWSome' \
    --set datasources."datasources\.yaml".apiVersion=1 \
    --set datasources."datasources\.yaml".datasources[0].name=Prometheus \
    --set datasources."datasources\.yaml".datasources[0].type=prometheus \
    --set datasources."datasources\.yaml".datasources[0].url=http://prometheus-server.prometheus.svc.cluster.local \
    --set datasources."datasources\.yaml".datasources[0].access=proxy \
    --set datasources."datasources\.yaml".datasources[0].isDefault=true \
    --set service.type=LoadBalancer

Jenkins for CI 

helm install --name cicd stable/jenkins --set rbac.create=true,master.servicePort=80,master.serviceType=LoadBalancer

kubectl get pods -w

For Admin password 

printf $(kubectl get secret --namespace default cicd-jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo


#Helm chart 

helm create spree-app1
Define the ingress resources on values.yaml 

helm install RELEASE-NAME spree-app1/


##Build and DEPLOY the code

Build Phase 
Build docker image and push to docker hub
docker build -t username/app1:0.2.0 .
docker login

docker push username/app1:0.2..0 

#Deploy Phase 

Edit the values.yaml or used sed command for same 

helm upgrade RELEASE-NAME spree-app1




