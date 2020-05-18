#!/bin/bash

cd $HELM_PLUGIN_DIR

unameOut="$(uname -s)"

case "${unameOut}" in
    Linux*)     art=agent_linux_sys; tgt=agent;;
    Darwin*)    art=agent_darwin_sys; tgt=agent ;;
    CYGWIN*)    art=agent_windows_sys.exe; tgt=agent.exe;;
    MINGW*)     art=agent_windows_sys.exe; tgt=agent.exe;;
    *)          art="UNKNOWN:${unameOut}"
esac

url="https://github.com/Enterprise-connect/sdk/raw/v1.1beta/dist/agent/${art}.tar.gz"

# download the archive using curl or wget
if [ -n $(command -v curl) ]
then
    curl -LOk $url
elif [ -n $(command -v wget) ]
then
    wget $url
else
    echo "missing curl  wget"
    exit -1
fi

# extract the plugin binary into the bin dir
rm -rf bin && mkdir bin && tar xzvf $art.tar.gz > /dev/null && mv $art $tgt && rm -f $art.tar.gz
