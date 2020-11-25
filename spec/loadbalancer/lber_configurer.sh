#! /bin/bash

# Goal: Prepare upstream blocks based on IP List
GATEWAY_LIST=$1

# Read the Gatewaylist input and split the string into array
gatewayhostarray=($GATEWAY_LIST)

masterupstream="upstream master {"
upstreamstr=""

for hostentry in "${gatewayhostarray[@]}"
do
  upstreamstr="$upstreamstr
upstream $hostentry {
  server $hostentry
}
  "
  masterupstream="$masterupstream
  server $hostentry"
done

masterupstream="$masterupstream
}"
upstreamstr="$masterupstream""$upstreamstr"
echo "$upstreamstr"
return "$upstreamstr"