#!/bin/bash
set -eo pipefail # script will exit on error

. $(dirname $0)/shared.sh # source common functions

# Must have AWS CLI installed, AWS profile configured and AWS region set

account_id=$(aws sts get-caller-identity --query Account --output text)

region=$(getRegion)
stack_name=$(getParam "stack_name")

echo "Deleting stack: ${stack_name} in region: ${region}"

aws cloudformation delete-stack --region ${region} --stack-name ${stack_name}

echo "Waiting for stack: ${stack_name} to complete..."
aws cloudformation wait stack-delete-complete --region ${region} --stack-name ${stack_name} 