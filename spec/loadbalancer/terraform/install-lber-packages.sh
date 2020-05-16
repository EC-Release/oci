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

$(pwd)/install-mandatory-packages.sh
