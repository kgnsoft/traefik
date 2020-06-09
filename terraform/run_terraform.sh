#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

echo -e "Getting the STS"
thests=$(aws sts assume-role --role-arn arn:aws:iam::260563756810:role/TerraformBuild --role-session-name ncds-infrastructure)

echo -e "$thests"

export AWS_SECRET_ACCESS_KEY=$(echo $thests | jq '.Credentials["SecretAccessKey"]' | tr -d '"')
export AWS_ACCESS_KEY_ID=$(echo $thests | jq '.Credentials["AccessKeyId"]' | tr -d '"')
export AWS_SESSION_TOKEN=$(echo $thests | jq '.Credentials["SessionToken"]' | tr -d '"')

echo -e "Current s3 buckets in selected account:" 
aws s3 ls s3://

case "$1" in 
	init) 
		terraform init
		;;
	plan)
		terraform plan
		;;

	apply)
		terraform apply
		;;
	destroy)
		terraform destroy
		;;
	graph)
		terraform graph
		;;
	validate)
		terraform validate
		;;
	*)
		echo $"Usage: $0 {init|plan|apply|destroy|graph|validate}"
		exit 1
esac

# ./<run_terraform> init|plan|apply|destroy appropriately 
