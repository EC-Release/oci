#!/bin/bash
#
#

echo "Installing Qualsys"
os_version=`cat /etc/os-release | egrep ^NAME= | cut -d= -f2 | cut -d\" -f2| awk '{print $1}'`
case $os_version in
  Amazon)
    echo "This is Amazon Linux"
    yum upgrade -y
    cd /tmp
    echo "Installing Qualsys..."
    wget -k https://s3.amazonaws.com/ge-digital-public-cloudops-public/binaries/qualys-cloud-agent.x86_64.rpm
    rpm -ivh /tmp/qualys-cloud-agent.x86_64.rpm
    service qualys-cloud-agent start
    ;;
  Ubuntu)
    echo "This is Ubuntu Linux"
    apt-get update
    cd /tmp
    echo "Installing Qualsys..."
    wget -k https://s3.amazonaws.com/ge-digital-public-cloudops-public/binaries/qualys-cloud-agent.x86_64.deb
    dpkg -i /tmp/qualys-cloud-agent.x86_64.deb
    systemctl start qualsys-cloud-agent
    ;;
  *)
    echo "Check the script"
    exit 1
esac

ldconfig
#Activate qualsys
echo "Installing Keys"
/usr/local/qualys/cloud-agent/bin/qualys-cloud-agent.sh ActivationId=b2d22492-d164-4262-86ea-530153f9fcc8  CustomerId=9c0e25de-0221-5af6-e040-10ac13043f6a
echo "Sleeping for 60 seconds"
sleep 60
#Check if install is success
ret_status=`cat /var/log/qualys/qualys-cloud-agent.log | grep -e "AgentID" | cut -d '{' -f4 | cut -d ':' -f3 | cut -d ',' -f1 | sed 's/"//g' | tail -n 1`
if [ -z $ret_status ]
then
  echo "CloudSys Install Failed"
  #exit 1
else
  echo "CloudSys Install Success"
fi
#Instructions to Remove
#systemctl stop qualsys-cloud-agent
#dpkg -r qualys-cloud-agent
#yum remove qualys-cloud-agent -y


echo "Installing Crowdstrike..........."
os_version=`cat /etc/os-release | egrep ^NAME= | cut -d= -f2 | cut -d\" -f2| awk '{print $1}'`
case $os_version in
  Amazon)
    echo "This is Amazon Linux 2"
    yum upgrade -y
    cd /tmp
    echo "Installing Crowdstrike..."
    wget https://s3.amazonaws.com/ge-digital-public-cloudops-public/binaries/falcon-sensor.amzn2.x86_64.rpm
    rpm -ivh /tmp/falcon-sensor.amzn2.x86_64.rpm
    service start falcon-sensor
    ;;
  Ubuntu)
    echo "This is Ubuntu Linux"
    apt-get update
    cd /tmp
    echo "Installing Crowdstike..."
    wget -k https://s3.amazonaws.com/ge-digital-public-cloudops-public/binaries/falcon-sensor_amd64.deb
    dpkg -i /tmp/falcon-sensor_amd64.deb
    systemctl start falcon-sensor
    ;;
  *)
    echo "Check the script"
    exit 1
esac
