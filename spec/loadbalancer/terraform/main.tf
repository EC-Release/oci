provider "aws" {
  region  = var.aws_region
}

resource "aws_instance" "dc-ec-gateway-vm" {
  count                       = var.aws_instance_gw.count
  ami                         = var.aws_instance_gw.ami
  instance_type               = var.aws_instance_gw.instance_type
  subnet_id                   = var.aws_instance_gw.subnet_id
  security_groups             = var.aws_instance_gw.security_groups
  key_name                    = var.aws_instance_gw.key_name
  iam_instance_profile        = var.aws_instance_gw.iam_instance_profile
  associate_public_ip_address = var.aws_instance_gw.associate_public_ip_address
  user_data                   = <<-EOF
#! /bin/bash

sudo su -

mkdir -p ~/ec-gateway

echo -e "ec-config:
  conf:
    mod: ${var.aws_instance_gw.watcher_mod}
    gpt: ${var.aws_instance_gw.watcher_gpt}
    zon: ${var.aws_instance_gw.watcher_zon}
    grp: ${var.aws_instance_gw.watcher_grp}
    sst: ${var.aws_instance_gw.watcher_sst}
    dbg: ${var.aws_instance_gw.watcher_dbg}
    tkn: ${var.aws_instance_gw.watcher_tkn}
    hst: ${var.aws_instance_gw.watcher_hst}
    cps: ${var.aws_instance_gw.watcher_cps}
  watcher:
    env: ${var.aws_instance_gw.watcher_env}
    license: ${var.aws_instance_gw.watcher_license}
    role: ${var.aws_instance_gw.watcher_role}
    devId: ${var.aws_instance_gw.watcher_devId}
    scope: ${var.aws_instance_gw.watcher_scope}
    certsDir: ${var.aws_instance_gw.watcher_certsDir}
    mode: ${var.aws_instance_gw.watcher_mode}
    os: ${var.aws_instance_gw.watcher_os}
    arch: ${var.aws_instance_gw.watcher_arch}
    instance: ${var.aws_instance_gw.watcher_instance}
    duration: ${var.aws_instance_gw.watcher_duration}
    cpuPeriod: ${var.aws_instance_gw.watcher_cpuPeriod}
    cpuQuota: ${var.aws_instance_gw.watcher_cpuQuota}
    cpuShared: ${var.aws_instance_gw.watcher_cpuShared}
    inMemory: ${var.aws_instance_gw.watcher_inMemory}
    swapMemory: ${var.aws_instance_gw.watcher_swapMemory}
    oauth2: ${var.aws_instance_gw.watcher_oauth2}
    httpPort: ${var.aws_instance_gw.watcher_httpPort}
    tcpPort: ${var.aws_instance_gw.watcher_tcpPort}
    customPort: ${var.aws_instance_gw.watcher_customPort}
    contRev: ${var.aws_instance_gw.watcher_contRev}
    contArtURL: ${var.aws_instance_gw.watcher_contArtURL}
"> ~/ec-gateway/config.yml

echo "Installing packges for EC gateway...... " >> /tmp/other-logs.txt

os_version=`cat /etc/os-release | egrep ^NAME= | cut -d= -f2 | cut -d\" -f2| awk '{print $1}'`
case $os_version in
  Amazon)
    yum update -y >> /tmp/update-logs.txt
    yum install docker -y >> /tmp/docker-install-logs.txt
    service docker start
    usermod -a -G docker ssm-user
    docker info >> /tmp/docker-info.txt
    docker pull busybox >> /tmp/docker-pull-busybox-logs.txt
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
    ;;
  *)
    echo "Check the OS version"
    exit 1
esac

# Download the agent binary
cd ~/ec-gateway/
wget https://github.com/Enterprise-connect/sdk/blob/v1.1beta/dist/agent/agent_linux_sys.tar.gz?raw=true -O agent_linux_sys.tar.gz
tar -xvzf agent_linux_sys.tar.gz
rm agent_linux_sys.tar.gz -f

export EC_CSC=${var.aws_instance_gw.watcher_passphrase}

echo "EC_CSC: $EC_CSC" >> /tmp/other-logs.txt
echo "pwd: $(pwd)" >> /tmp/other-logs.txt
echo "whoami: $(whoami)" >> /tmp/other-logs.txt

./agent_linux_sys -cfg config.yml -wtr > /tmp/watcher-start-logs.txt

# Install mandatory packages
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

EOF

  root_block_device {
    encrypted = true
  }

  tags = {
    Name           = "dc-ec-gateway-${count.index + 1}"
    Env            = var.aws_instance_gw.tags.Env
    Engineer_Email = var.aws_instance_gw.tags.Engineer_Email
    Engineer_SSO   = var.aws_instance_gw.tags.Engineer_SSO
    Best_By        = var.aws_instance_gw.tags.Best_By
    UAI            = var.aws_instance_gw.tags.UAI
    Builder        = var.aws_instance_gw.tags.Builder
  }
}

resource "aws_instance" "dc-ec-gateway-lber-vm" {
  ami                         = var.aws_instance_lber.ami
  instance_type               = var.aws_instance_lber.instance_type
  subnet_id                   = var.aws_instance_lber.subnet_id
  security_groups             = var.aws_instance_lber.security_groups
  key_name                    = var.aws_instance_lber.key_name
  iam_instance_profile        = var.aws_instance_lber.iam_instance_profile
  associate_public_ip_address = var.aws_instance_lber.associate_public_ip_address

  user_data = <<-EOF
#! /bin/bash

sudo su -

mkdir -p ~/ec-loadbalancer

echo "Gateway VM's count: ${var.aws_instance_gw.count}" >> /tmp/other-logs.txt

# TODO: Make it dynamic
echo "IP1=${aws_instance.dc-ec-gateway-vm[0].private_ip}" >> ~/ec-loadbalancer/environment.env
echo "DNS_NAME=${var.aws_instance_gw.watcher_lber_dnsname}" >> ~/ec-loadbalancer/environment.env

echo "Installing and run docker...... " >> /tmp/other-logs.txt
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
    docker run -d -p 80:80 --env-file ~/ec-loadbalancer/environment.env enterpriseconnect/loadbalancer:v1.1beta-nontls
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

EOF

  root_block_device {
    encrypted = true
  }

  tags = {
    Name           = var.aws_instance_lber.tags.Name
    Env            = var.aws_instance_lber.tags.Env
    Engineer_Email = var.aws_instance_lber.tags.Engineer_Email
    Engineer_SSO   = var.aws_instance_lber.tags.Engineer_SSO
    Best_By        = var.aws_instance_lber.tags.Best_By
    UAI            = var.aws_instance_lber.tags.UAI
    Builder        = var.aws_instance_lber.tags.Builder
  }
}