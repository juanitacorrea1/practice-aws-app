#!/bin/bash
set -eo pipefail # script will exit on error

. $(dirname $0)/shared.sh # source common functions

echo "Linting CloudFormation templates"
cfn-lint cloudformation/*