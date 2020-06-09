include .env
export $(shell sed 's/=.*//' .env)



terraform-init: 
cd terraform && terraform init && cd -

terraform-plan:
cd terraform && \
terraform apply && \
cd -

packer-build:
cd packer && \
packer build inboundproxy.json && \
cd -

