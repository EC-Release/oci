#! /bin/bash

# Goal: Prepare upstream blocks based on IP List
GATEWAY_LIST=$1

# Read the Gatewaylist input and split the string into array
gatewayhostarray=($GATEWAY_LIST)

masterupstream="upstream master {"
upstreamstr="\n"
count=0

for hostentry in "${gatewayhostarray[@]}"
do
  count=$(( $count + 1 ))
  upstreamstr="$upstreamstr\nupstream vm$count {\n  server $hostentry;\n}\n"
  masterupstream="$masterupstream\n  server $hostentry;"
  
done

masterupstream="$masterupstream\n}"
upstreamstr="$masterupstream""$upstreamstr"
echo "$upstreamstr" > ./temp
