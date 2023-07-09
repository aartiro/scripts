#!/bin/bash
echo -n "Enter AWS Profile: "
read OPTION
export AWS_PROFILE="$OPTION"
export AWS_DEFAULT_REGION=us-west-2
#profile="uat-test"
echo -n "Enter Target Name: "
read OPTION
target_group_name="$OPTION"
#target_group_name="test-uat-tg-2"
echo -n "Enter Instance Name which want to register/deregister: "
read OPTION
#instance_name="$OPTION"

instance_id="$(aws ec2 describe-instances --filters Name=tag:Name,Values="$OPTION" --query "Reservations[*].Instances[*].InstanceId" --output text)"
#instance_id="i-0ca774dc148b7dac9"

#target_group_arn="arn:aws:elasticloadbalancing:us-west-2:542677674440:targetgroup/test-uat-tg-2/41ea390ab365c368"

#list_of_instances=$(aws elb describe-load-balancers --load-balancer-names test-uat-alb --output text --query "LoadBalancerDescriptions[*].Instances[*].InstanceId")
target_group_arn="$(aws elbv2 describe-target-groups --query 'TargetGroups[].[TargetGroupArn]' --names "$target_group_name" --profile "$1" --output text)"

echo -n "Enter the option you want to do (enter register for register and enter deregister for deregister): "
read OPTION
case $OPTION in 
  register)
    if register_output=$(aws elbv2 register-targets --target-group-arn "$target_group_arn" --targets Id="$instance_id"); 
    then
      echo "Registering instance into target group. Please wait for 5 minutes registration progress finished"
    else
      echo "!!!! ERROR !!!!"
    fi
    ;;
  deregister) 
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