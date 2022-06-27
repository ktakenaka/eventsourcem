#!/bin/bash
AWS_ACCESS_KEY_ID=accesskey
AWS_SECRET_ACCESS_KEY=secret
REGION=ap-northeast-1

# Configuration
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set region $REGION

# Create sample queue
awslocal sqs create-queue --queue-name sample
