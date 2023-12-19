#/bin/bash
img_id=ami-03265a0778a880afb
sg_id=sg-096e94616125ed979
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")
ZONE_ID=ZZ1024693OKJAW10DDB2X
DOMAIN_NAME="pavankumarmuvva.online"


for i in "${INSTANCES[@]}"
do
  if [ $i == "mongodb" ] || [ $i == "shipping" ] || [ $i == "mysql" ]
    then 
    Instance_Type="t3.micro"
    else
    Instance_Type="t2.micro"
  fi  
  IP_ADDRESS=$(aws ec2 run-instances --image-id $img_id --instance-type $Instance_Type --security-group-ids $sg_id --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text)
  echo "$i::$IP_ADDRESS"
done

<<com
  #create R53 record, make sure you delete existing record
    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
    {
        "Comment": "Creating a record set for cognito endpoint"
        ,"Changes": [{
        "Action"              : "CREATE"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$i'.'$DOMAIN_NAME'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$IP_ADDRESS'"
            }]
        }
        }]
    }
        '
done

com


