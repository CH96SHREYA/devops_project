#!/bin/bash

#####################################
# Author: Shreya
# Date: 8 Jan 2024
# Version: v1
# The purpose of the script is to number of aws instances currently in use
# Resource: EC2, S3, IAM users, lambda
###########################################

set -x
set -e
set -o  pipefail
set -u

OUTPUT_FILE="currentUsage"

# Clear the output file before writing
> "$OUTPUT_FILE"

# Function to list s3 buckets
list_s3_buckets() {
echo "List of s3 buckets: " >> "$OUTPUT_FILE" 
aws s3 ls >> "$OUTPUT_FILE" || echo "Failed to list S3 buckets" >> "$OUTPUT_FILE"
}

list_ec2_instances() {
echo "List of ec2 instances" >> "$OUTPUT_FILE"
aws ec2 describe-instances | jq '.Reservations[].Instances[].InstanceId' >> "$OUTPUT_FILE" || echo "Failed to list ec2 instances" >> "$OUTPUT_FILE"
}


list_lambda() {
echo "List of lambda" >> "$OUTPUT_FILE"
aws lambda list-functions >> "$OUTPUT_FILE" || echo "Failed to list lambda functions"
}



list_iam_user() {
echo "List of IAM users" >> "$OUTPUT_FILE"
aws iam list-users | jq '.Users[].UserName'>> "$OUTPUT_FILE" || echo "Failed to list iam users"
}


# Execute the functions
list_s3_buckets
list_ec2_instances
list_lambda
list_iam_user


echo "Resource listing completed. Check $OUTPUT_FILE for details"
