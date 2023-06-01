#!/bin/bash
###
### Encrypt K8S Files with Secrets
###
FILE=$1
export KEY_AGE=$(cat `git rev-parse --show-toplevel`/.age.pub)
# Get root directory of git repo
ROOT_DIR=$(git rev-parse --show-toplevel)

# Set the age key
export SOPS_AGE_KEY_FILE=$ROOT_DIR/age.agekey

sops --decrypt --encrypted-regex '^(data|stringData)$' --in-place $FILE