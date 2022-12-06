#!/bin/bash
# Source this file to get common functions
# Must have AWS CLI installed, AWS profile configured and AWS region set

# Get the current AWS account ID
function getAccountId() {
  aws sts get-caller-identity --query Account --output text
}

# Get parameter from the parameters file
function getParam() {
  param=$1
  cat parameters.yml | yq -r ".${param}"
}

# Order of prescedence:
# AWS_REGION <env var>
# AWS_DEFAULT_REGION <env var>
# aws configure get region
# parameters.yml -> .region
function getRegion() {
  cfg_region=$(aws configure get region)
  if [[ "${AWS_REGION}" != "" ]]; then
    region=${AWS_REGION}
  elif [[ "${AWS_DEFAULT_REGION}" != "" ]]; then
    region=${AWS_DEFAULT_REGION}
  elif [[ "${cfg_region}" != "" ]]; then
    region=${cfg_region}
  else
    region=$(getParam "region")
  fi
  echo $region
}
