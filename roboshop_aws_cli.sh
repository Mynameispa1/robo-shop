#/bin/bash
img_id=ami-03265a0778a880afb
sg_id=sg-096e94616125ed979
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")

for i in "${INSTANCES[@]}"
do
  if [ $i == "mongodb" ] || [ $i == "shipping" ] || [ $i == "mysql" ]
    then 
    Instance_Type="t3.micro"
    else
    Instance_Type="t2.micro"
    aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type $Instance_Type --security-group-ids sg-096e94616125ed979
done
