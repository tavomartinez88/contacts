####Requeriments
- Terraform >= v0.13.2
- Golag 1.x

#####Init
- set region and profile to provider
- cd terraform && terraform init
- terraform plan && terraform apply

#####AWS-Lambda
##### create-contact-aws-lambda
- building: 
    -  sh build/build.sh

#####Deploy
- terraform plan && terraform apply