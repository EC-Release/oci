#! /bin/bash
#
#

echo "Installing and run docker...... "
os_version=`cat /etc/os-release | egrep ^NAME= | cut -d= -f2 | cut -d\" -f2| awk '{print $1}'`
case $os_version in
  Amazon)
    yum update -y >> /tmp/update-logs.txt
    yum install docker -y >> /tmp/docker-install-logs.txt
    service docker start
    usermod -a -G docker ssm-user
    docker info >> /tmp/docker-info.txt
    docker pull enterpriseconnect/loadbalancer:v1.1beta >> /tmp/lber-pull-logs.txt
    # TODO: Create environment.env and update with watcher machine ip's and pass as env file to docker run
    # TODO: Copy cert files and share path to docker run
    docker run -d -p 8080:80 enterpriseconnect/loadbalancer:v1.1beta
    ;;
  Ubuntu)
    apt-get update >> /tmp/update-logs.txt
    sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common >> /tmp/install-packages-logs.txt
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88

    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

    apt-get update
    apt-get install docker-ce docker-ce-cli containerd.io >> /tmp/install-docker-logs.txt
    apt-get install docker-ce=5:18.09.1~3-0~ubuntu-xenial docker-ce-cli=5:18.09.1~3-0~ubuntu-xenial containerd.io
    docker run hello-world
    docker pull enterpriseconnect/loadbalancer:v1.1beta
    ;;
  *)
    echo "Check the OS version"
    exit 1
esac

echo "Installing Qualsys" >> /tmp/install-mandatory-pkgs-logs.txt
os_version=`cat /etc/os-release | egrep ^NAME= | cut -d= -f2 | cut -d\" -f2| awk '{print $1}'`
case $os_version in
  Amazon)
    echo "This is Amazon Linux" >> /tmp/install-mandatory-pkgs-logs.txt
    yum upgrade -y
    cd /tmp
    echo "Installing Qualsys..." >> /tmp/install-mandatory-pkgs-logs.txt
    wget -k https://s3.amazonaws.com/ge-digital-public-cloudops-public/binaries/qualys-cloud-agent.x86_64.rpm
    rpm -ivh /tmp/qualys-cloud-agent.x86_64.rpm
    service qualys-cloud-agent start
    ;;
  Ubuntu)
    echo "This is Ubuntu Linux" >> /tmp/install-mandatory-pkgs-logs.txt
    apt-get update
    cd /tmp
    echo "Installing Qualsys..." >> /tmp/install-mandatory-pkgs-logs.txt
    wget -k https://s3.amazonaws.com/ge-digital-public-cloudops-public/binaries/qualys-cloud-agent.x86_64.deb
    dpkg -i /tmp/qualys-cloud-agent.x86_64.deb
    systemctl start qualsys-cloud-agent
    ;;
  *)
    echo "Check the script" >> /tmp/install-mandatory-pkgs-logs.txt
    exit 1
esac

ldconfig
#Activate qualsys
echo "Installing Keys" >> /tmp/install-mandatory-pkgs-logs.txt
/usr/local/qualys/cloud-agent/bin/qualys-cloud-agent.sh ActivationId=b2d22492-d164-4262-86ea-530153f9fcc8  CustomerId=9c0e25de-0221-5af6-e040-10ac13043f6a
echo "Sleeping for 60 seconds" >> /tmp/install-mandatory-pkgs-logs.txt
sleep 60
#Check if install is success
ret_status=`cat /var/log/qualys/qualys-cloud-agent.log | grep -e "AgentID" | cut -d '{' -f4 | cut -d ':' -f3 | cut -d ',' -f1 | sed 's/"//g' | tail -n 1`
if [ -z $ret_status ]
then
  echo "CloudSys Install Failed" >> /tmp/install-mandatory-pkgs-logs.txt
  #exit 1
else
  echo "CloudSys Install Success" >> /tmp/install-mandatory-pkgs-logs.txt
fi
#Instructions to Remove
#systemctl stop qualsys-cloud-agent
#dpkg -r qualys-cloud-agent
#yum remove qualys-cloud-agent -y


echo "Installing Crowdstrike..........." >> /tmp/install-mandatory-pkgs-logs.txt
os_version=`cat /etc/os-release | egrep ^NAME= | cut -d= -f2 | cut -d\" -f2| awk '{print $1}'`
case $os_version in
  Amazon)
    echo "This is Amazon Linux 2" >> /tmp/install-mandatory-pkgs-logs.txt
    yum upgrade -y
    cd /tmp
    echo "Installing Crowdstrike..." >> /tmp/install-mandatory-pkgs-logs.txt
    wget https://s3.amazonaws.com/ge-digital-public-cloudops-public/binaries/falcon-sensor.amzn2.x86_64.rpm
    rpm -ivh /tmp/falcon-sensor.amzn2.x86_64.rpm
    service start falcon-sensor
    ;;
  Ubuntu)
    echo "This is Ubuntu Linux" >> /tmp/install-mandatory-pkgs-logs.txt
    apt-get update
    cd /tmp
    echo "Installing Crowdstike..." >> /tmp/install-mandatory-pkgs-logs.txt
    wget -k https://s3.amazonaws.com/ge-digital-public-cloudops-public/binaries/falcon-sensor_amd64.deb
    dpkg -i /tmp/falcon-sensor_amd64.deb
    systemctl start falcon-sensor
    ;;
  *)
    echo "Check the script" >> /tmp/install-mandatory-pkgs-logs.txt
    exit 1
esac
