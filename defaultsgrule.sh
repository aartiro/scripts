#!/bin/bash

# Prompt for AWS profile
# read -p "Enter AWS profile name: " aws_profile
export AWS_PROFILE="saml" #$aws_profile

# List of all AWS regions
regions=(
    "us-east-1"
    "us-east-2"
    "us-west-1"
    "us-west-2"
    "ap-south-1"
    "ap-northeast-3"
    "ap-northeast-2"
    "ap-southeast-1"
    "ap-southeast-2"
    "ap-northeast-1"
    "ca-central-1"
    "eu-central-1"
    "eu-west-1"
    "eu-west-2"
    "eu-west-3"
    "eu-north-1"
    "sa-east-1"
    # Add more regions as needed
)

# Loop through each region
for region in "${regions[@]}"; do
  echo "Processing region: $region"
  
  # Get the default security group ID for the region
  default_group_id=$(aws ec2 describe-security-groups --region "$region" --filters "Name=group-name,Values=default" --query "SecurityGroups[*].GroupId" --output text)
  
  for sg_id in $default_group_id; do
  # Apply tags to the default security group
  aws ec2 create-tags --region "$region" --resources "$sg_id" --tags Key=Name,Value="Default Security Group" Key=defaultsg,Value="True"
  echo "Tags applied to default security group: $sg_id"
  done
done
