#/bin/bash

AMI=ami-03265a0778a880afb
SG=sg-096e94616125ed979
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")

for i in "${INSTANCES[@]}"
do
   if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
     then
         INSTANCE_TYPE=t3.micro
     else
         INSTANCE_TYPE=t2.micro
      fi    
   aws ec2 run-instances --image-id ami-03265a0778a880afb --count 1 --instance-type $INSTANCE_TYPE
   --security-group-ids sg-096e94616125ed979 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text)
done


