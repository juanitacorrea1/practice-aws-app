#!/bin/bash
set -eo pipefail # script will exit on error

. $(dirname $0)/shared.sh # source common functions

account_id=$(getAccountId)
region=$(getRegion)
stack_name=$(getParam "stack_name")
bucket_name="$(getParam "bucket_base_name")-${region}-${account_id}" # append account ID to make bucket name globally unique
lock_table_name=$(getParam "lock_table_name")

echo "Deploying stack: ${stack_name} in region: ${region}"

# TODO split into package and deploy (currently not idempotent)
# TODO add tags
aws cloudformation create-stack --region ${region} --stack-name ${stack_name} \
    --template-body file://cloudformation/backend.yaml \
    --parameters ParameterKey=StateBucketName,ParameterValue=${bucket_name} ParameterKey=LockTableName,ParameterValue=${lock_table_name} \
    --no-cli-pager

echo "Waiting for stack: ${stack_name} to complete..."
aws cloudformation wait stack-create-complete --region ${region} --stack-name ${stack_name} 
