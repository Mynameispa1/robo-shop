#!bin/bash
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[34m"

TIMESTAMP=$(date +%F-%H-%M-%S)
Log_Path="/tmp/$0-$TIMESTAMP"

VALIDATE (){
if [ $1 -ne 0 ]
then
  echo -e "$R $2 is FAILED $N"
  exit 1
else
  echo -e "$G $2 is SUCCESS $N"
fi  
}

if [ $ID -ne 0 ]
then
  echo -e "Error:: $R Please run script with root user $N"
  exit 1
else
  echo -e "$G You are running with root user $N"

fi

cp mongo.repo /etc/yum.repos.d/ &>> $Log_Path
VALIDATE $? "copied mangodb repo"

dnf install mongodb-org -y 
VALIDATE $? "Installed mongodb"

systemctl enable mongod
VALIDATE $? "Enaballed mongodb"

systemctl start mongod
VALIDATE $? "Started mongodb"

sed -i 's/127.0.0.0/0.0.0.0/g' /etc/mongod.conf


