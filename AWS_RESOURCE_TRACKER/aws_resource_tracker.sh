#!/bin/bash 

################################
# Author : T Venkata Viswas
# Date   : 04-11-2024
#
# Version : v1
#
# This script will report the AWS resource usage 
###############################

set -e  # Exit immediately if any command fails

# Check if AWS CLI is installed
if ! aws --version &>/dev/null; then
    echo "AWS CLI is not installed. Please install the AWS CLI and run the script again."
    exit 1
fi

# Define the output file for resource tracking
resourceTracker="resourceTracker"

# Clear the resourceTracker file to start fresh
> "$resourceTracker"

# List S3 buckets and append to resourceTracker
echo "Listing S3 buckets..."
echo "S3 Buckets:" >> "$resourceTracker"
aws s3 ls | awk '{print "Bucket Name: " $3}' >> "$resourceTracker"  

# List EC2 Instances and append their IDs to resourceTracker
echo "Listing EC2 instances..."
echo "EC2 Instances:" >> "$resourceTracker"
aws ec2 describe-instances | jq -r ".Reservations[].Instances[].InstanceId" | awk '{print "Instance ID: " $0}' >> "$resourceTracker" 

# List Lambda functions and append their names to resourceTracker
echo "Listing Lambda functions..."
echo "Lambda Functions:" >> "$resourceTracker"
aws lambda list-functions | jq -r ".Functions[].FunctionName" | awk '{print "Function Name: " $0}' >> "$resourceTracker"

# List IAM Users and append their usernames to resourceTracker
echo "Listing IAM users..."
echo "IAM Users:" >> "$resourceTracker"
aws iam list-users | jq -r ".Users[].UserName" | awk '{print "Username: " $0}' >> "$resourceTracker"

# Inform the user that the report has been generated
echo "Resource usage report has been generated in $resourceTracker."

