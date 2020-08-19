Infra launching 

terraform init 
terraform plan 
terraform apply 

##Build and DEPLOY the code

Build Phase 
Build docker image and push to docker hub
docker build -t username/app1 .
docker login

docker push username/app1:latest


