#!/bin/bash
###
### Encrypt K8S Files with Secrets
###
FILE=$1
# Get root directory of git repo
export ROOT_DIR=$(git rev-parse --show-toplevel)
export KEY_AGE=$(cat $ROOT_DIR/.age.pub)


# Set the age key
export SOPS_AGE_KEY_FILE=$ROOT_DIR/age.agekey

sops --encrypt --encrypted-regex '^(data|stringData)$' --in-place $FILE