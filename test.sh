#!/bin/bash

STACKS_COUNT=$(echo $STACKS | jq --arg stack "ca-roles-aws-cicd-prototyp-base-infrastructure-prod-master" '.StackSummaries[] | select(.StackName==$stack) | .StackId' | jq --slurp '. | length')

echo $STACKS_COUNT

if [ $STACKS_COUNT = "0" ]
then
  echo "not null"
else
  echo "null"
fi
