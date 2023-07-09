#!/bin/bash
echo -n "Enter AWS Profile: "
read OPTION
export AWS_PROFILE="$OPTION"
export AWS_DEFAULT_REGION=us-west-2
echo -n "Enter Target Name: "
read OPTION
target_group_name="$OPTION"
echo -n "Enter Instance Name which want to register/deregister: "
read OPTION

instance_id="$(aws ec2 describe-instances --filters Name=tag:Name,Values="$OPTION" --query "Reservations[*].Instances[*].InstanceId" --output text)"

#target_group_arn="arn:aws:elasticloadbalancing:us-west-2:542677674440:targetgroup/test-uat-tg-2/41ea390ab365c368"

target_group_arn="$(aws elbv2 describe-target-groups --query 'TargetGroups[].[TargetGroupArn]' --names "$target_group_name" --profile "$1" --output text)"

echo -n "Enter the option you want to do (enter 1 for register and enter 2 for deregister): "
read OPTION
case $OPTION in 
  1)
    if register_output=$(aws elbv2 register-targets --target-group-arn "$target_group_arn" --targets Id="$instance_id"); 
    then
      echo "Registering instance into target group. Please wait for 5 minutes registration progress finished"
    else
      echo "!!!! ERROR !!!!"
    fi
    ;;
  2) 
    if deregister_output=$(aws elbv2 deregister-targets --target-group-arn "$target_group_arn" --targets Id="$instance_id"); 
    then
      echo "Deregistering instance into target group. Please wait for 5 minutes registration progress finished"
    else
      echo "!!!! ERROR !!!!"
   fi
    ;;
  *)
    echo "unknown option"
    ;;
esac