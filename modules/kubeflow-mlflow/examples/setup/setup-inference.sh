#!/bin/bash

TOKEN=$1
NAMESPACE=$2

kubectl create secret generic hf-secret \
  --from-literal=HF_TOKEN="$TOKEN" \
  -n $NAMESPACE

