[![Build Status](https://travis-ci.com/Enterprise-connect/oci.svg?branch=v1)](https://travis-ci.com/Enterprise-connect/oci)

# EC OCI Spec
**Running the EC agent artifact within a docker image is not recommended due the dependancy of the underlying linux cgroup with docker.** The cgroup which lives in the docker core requires a sudoer permission from the guest system. Docker users who wish to run a secondary user other than the root user within a container should **avoid the volume-sharing on the guest host**. The root permission would defeat the purpose of EC rootless-connectivity model and ultimately create several security leaks on the guest host. However, it is worth to note that **running a standalone agent does NOT require a sudoer/root permission.** Please ref`er to [the agent source code repo for the standalone deployment](https://github.build.ge.com/Enterprise-Connect/agent#Usage). **Users with restrict security environemnt one such as AWS GovCloud should cosnider using a self-build image based on the given sample spec in this repo.**

EC Agent OCI image is currently maintained on [public docker hub](https://hub.docker.com/repository/docker/enterpriseconnect/agent); the usage spec avaialble in several compute environments. Visit the [EC usage examples](https://github.com/Enterprise-connect/ec-x-sdk/tree/v1/examples) or [the wiki if new to EC](https://github.com/Enterprise-connect/ec-sdk/wiki/EC-Agent).

OCI (Open Container Initiative) is a contionue trademark of [the Open Container Initiative Community](https://www.opencontainers.org/community) and currently [governed by the community charters](https://www.opencontainers.org/about/governance)

# Docker Tags
- [```v1```](https://github.com/Enterprise-connect/oci/blob/v1/spec/agent.Dockerfile), [```latest```](https://github.com/Enterprise-connect/oci/blob/v1/spec/agent.Dockerfile), [```v1-slim```](https://github.com/Enterprise-connect/oci/blob/v1/spec/agent.Dockerfile)
- ```v1-python```, ```v1-ci```
- [```v1beta```](https://github.com/Enterprise-connect/oci/blob/v1beta/spec/agent.Dockerfile), [```v1beta-slim```](https://github.com/Enterprise-connect/oci/blob/v1beta/spec/agent.Dockerfile)
- ```v1beta-python```, ```v1beta-ci```

### How to run
In this container spec example, the pre-defined agent image is launched by using docker. The agent flags in this example are converted into several environment variables that are required based on the ```<path/to/this/repo>/spec/<agent-mode>.yml``` for a EC usage. For instance, to launch a client-mode agent container, it is required to ingest env vars EC_AID, EC_TID, EC_HST, etc. 
  
The env variables specified in ```--env-file``` will need to be replaced by a series of relevant flags as it is shown in the example yaml file.
```shell
docker run --env-file client.list \
  enterpriseconnect/agent:v1
```
For the usage of docker flag ```-e```, please [refer to this example](https://github.com/Enterprise-connect/oci/blob/v1/.travis.yml#L11)

### Kubernates Deployment example
When deploy the agent in a k8s instance, the necessary environment variables as specified in the example ```/path/to/the/repo/k8s/agent-<object>.yml```.  k8s users may utilise any custom objects such as a configmap plugin to help in its configuration.



