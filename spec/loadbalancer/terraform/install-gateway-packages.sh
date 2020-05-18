#! /bin/bash
#
#

echo "Installing packges for installing EC gateway...... "

# TODO: Copy configuration yml file

# Download the agent binary
wget https://github.com/Enterprise-connect/sdk/blob/v1.1beta/dist/agent/agent_linux_sys.tar.gz?raw=true -O agent_linux_sys.tar.gz
tar -xvzf agent_linux_sys.tar.gz
rm agent_linux_sys.tar.gz -f

# TODO: Uncomment once configuration file avaiable to run watcher
# ./agent_linux_sys -cfg gateway.yml -wtr

$(pwd)/install-mandatory-packages.sh