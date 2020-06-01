provider "aws" {
  profile = var.aws_profile
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
  user_data = <<-EOF
#! /bin/bash
#
#

sudo su -

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
"> /tmp/config.yml

echo "Installing packges for installing EC gateway...... " >> /tmp/other-logs.txt

os_version=`cat /etc/os-release | egrep ^NAME= | cut -d= -f2 | cut -d\" -f2| awk '{print $1}'`
case $os_version in
  Amazon)
    yum update -y >> /tmp/update-logs.txt
    yum install docker -y >> /tmp/docker-install-logs.txt
    service docker start
    usermod -a -G docker ssm-user
    docker info >> /tmp/docker-info.txt
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
wget https://github.com/Enterprise-connect/sdk/blob/v1.1beta/dist/agent/agent_linux_sys.tar.gz?raw=true -O agent_linux_sys.tar.gz
tar -xvzf agent_linux_sys.tar.gz
rm agent_linux_sys.tar.gz -f

export EC_CSC=password

echo "EC_CSC: $EC_CSC" >> /tmp/other-logs.txt
echo "pwd: $(pwd)" >> /tmp/other-logs.txt
echo "whoami: $(whoami)" >> /tmp/other-logs.txt

./agent_linux_sys -cfg /tmp/config.yml -wtr > /tmp/watcher-start-logs.txt

$(pwd)/install-mandatory-packages.sh

EOF

  root_block_device {
    encrypted = true
  }

  tags = {
    Name           = var.aws_instance_gw.tags.Name
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
  key_name                    = var.aws_instance_gw.key_name
  iam_instance_profile        = var.aws_instance_lber.iam_instance_profile
  associate_public_ip_address = var.aws_instance_lber.associate_public_ip_address
  user_data                   = "${file("install-lber-packages.sh")}"
//  user_data                   = "replace(${file("watchr.yml"),"hsturl","wss:///agent"}"

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