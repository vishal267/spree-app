Infra launching 

terraform init 
terraform plan 
terraform apply 

##Build and DEPLOY the code

Build docker image and push to docker hub
docker build -t username/app1 .
docker push username/app1:latest

