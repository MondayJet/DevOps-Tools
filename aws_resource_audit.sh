#!/bin/bash
############################################################################################
# This Script will list all resources in AWS account based on supplied parameters
# Author: John Monday T.
# Version: v0.0.1
# Date: 12/22/2024
# Usage: ./aws_resource_audit.sh <aws_profile> <service_name>
# Example: ./aws_resource_audit.sh profile_name ec2
####################################################################################################

# Check if the required number of arguments is passed
if [ $# -ne 2 ]; then
    echo "Usage: $0 <aws_profile> <service_name>"
    echo "Example: ./aws_resource_audit.sh profile_name ec2"
    exit 1
fi

# Assign the arguments to variables
aws_profile=$1
service_name=$(echo "$2" | tr '[:upper:]' '[:lower:]') # Convert to lowercase

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it and try again."
    exit 1
fi

# Check if AWS CLI is configured
if [ ! -d ~/.aws ]; then
    echo "AWS CLI is not configured. Please configure the AWS CLI and try again."
    exit 1
fi

# List resources based on the service name
case $service_name in
ec2)
    echo "Listing the number of EC2 instances in $aws_profile"
    aws ec2 describe-instances --profile "$aws_profile" --query 'Reservations[*].Instances[*].[InstanceId]' --output text | wc -w
    ;;
rds)
    echo "Listing the RDS instances in $aws_profile"
    aws rds describe-db-instances --profile "$aws_profile"
    ;;
s3)
    echo "Listing the number of S3 buckets in $aws_profile"
    aws s3api list-buckets --profile "$aws_profile" --query "Buckets | length(@)" --output text
    ;;
dynamodb)
    echo "Listing DynamoDB tables in $aws_profile"
    aws dynamodb list-tables --profile "$aws_profile"
    ;;
lambda)
    echo "Listing Lambda functions in $aws_profile"
    aws lambda list-functions --profile "$aws_profile"
    ;;
ebs)
    echo "Listing EBS volumes in $aws_profile"
    aws ec2 describe-volumes --profile "$aws_profile"
    ;;
vpc)
    echo "Listing VPCs in $aws_profile"
    aws ec2 describe-vpcs --profile "$aws_profile"
    ;;
elb)
    echo "Listing ELBs in $aws_profile"
    aws elbv2 describe-load-balancers --profile "$aws_profile" --query 'LoadBalancers[*].[LoadBalancerName]' --output table
    ;;
cloudfront)
    echo "Listing CloudFront distributions in $aws_profile"
    aws cloudfront list-distributions --profile "$aws_profile" --query 'DistributionList.Items[*].[Id, DomainName]' --output table
    ;;
cloudwatch)
    echo "Listing CloudWatch metrics in $aws_profile"
    aws cloudwatch list-metrics --profile "$aws_profile" --output table
    ;;
sns)
    echo "Listing SNS topics in $aws_profile"
    aws sns list-topics --profile "$aws_profile"
    ;;
sqs)
    echo "Listing SQS queues in $aws_profile"
    aws sqs list-queues --profile "$aws_profile"
    ;;
route53)
    echo "Listing Route53 hosted zones in $aws_profile"
    aws route53 list-hosted-zones --profile "$aws_profile"
    ;;
cloudformation)
    echo "Listing CloudFormation stacks in $aws_profile"
    aws cloudformation list-stacks --profile "$aws_profile"
    ;;
iam)
    echo "Listing IAM users in $aws_profile"
    aws iam list-users --profile "$aws_profile"
    ;;
*)
    echo "Unsupported service: $service_name"
    echo "Supported services: ec2, rds, s3, dynamodb, lambda, ebs, vpc, elb, cloudfront, cloudwatch, sns, sqs, route53, cloudformation, iam"
    exit 1
    ;;
esac
