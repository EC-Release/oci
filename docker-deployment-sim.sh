#!/bin/bash
printf "\n\n\n*** test v1 agt mode w/ docker\n\n"
docker run -it --rm --env-file=k8s/example/gateway.env enterpriseconnect/agent:v1 > agt.log || cat agt.log
printf "\n\n\n*** test v1beta agt mode w/ docker\n\n"
docker run -it --rm --env-file=k8s/example/gateway.env enterpriseconnect/agent:v1beta > agt.log || cat agt.log

printf "\n\n\n*** test server+tls v1 plugin w/ docker\n\n"
#docker run -it --rm -d --name server-tls --env-file=k8s/example/server+tls.env enterpriseconnect/plugins:v1 && sleep 5 && docker logs server-tls 
docker run -it --rm -d --name server-tls --env-file=k8s/example/server+tls.env enterpriseconnect/plugins:v1 && sleep 10 && docker logs server-tls 
printf "\n\n\n*** test client+vln v1 plugin w/ docker\n\n"
docker run -it --rm -d --name client-vln --env-file=k8s/example/client+vln.env enterpriseconnect/plugins:v1 && sleep 5 && docker logs client-vln 
