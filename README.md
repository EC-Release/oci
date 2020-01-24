![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/enterpriseconnect/build)

# EC OCI Spec
**Running the EC agent artifact within a docker image is not recommended due the dependancy of the underlying linux cgroup with docker.**

The cgroup lives in the docker core which by design requires a sudoer permission from the guest system. Docker users who wish to level up the security by running a non-sudoer user **inside** the container should **avoid the volume-sharing on the guest host**.

Because of this, it is **highly recommended** to running this image as a rootless/unpriviliged container. Please refer to [runc](https://github.com/opencontainers/runc) and [linux cgroup man ```man cgroups```](http://man7.org/linux/man-pages/man7/cgroups.7.html) for further study.

The open-source projects adoption flow-
```cgroup >> runc + nsenter >> moby >> docker```

The root permission per se defeats the purpose of EC rootless-connectivity model and ultimately create several security leaks on the guest host. However, it is worth to note that **running a standalone agent does NOT require a sudoer/root permission.** Please refer to [the agent source code repo for the standalone deployment](https://github.build.ge.com/Enterprise-Connect/agent#Usage). **Users with restrict security environemnt one such as AWS GovCloud should consider using a self-build image based on the spec examples in this repo.**

The EC Agent OCI image is currently maintained on [public docker hub](https://hub.docker.com/repository/docker/enterpriseconnect/agent); the usage spec avaialble in several compute environments. Visit the [EC usage examples](https://github.com/Enterprise-connect/ec-x-sdk/tree/v1/examples) or [the wiki if new to EC](https://github.com/Enterprise-connect/ec-sdk/wiki/EC-Agent).

OCI (Open Container Initiative) is a contionue trademark of [the Open Container Initiative Community](https://www.opencontainers.org/community) and currently [governed by the community charters](https://www.opencontainers.org/about/governance)

# Docker Tags

## agent builds
#### run example
```docker run --env-file v1beta.list enterpriseconnect/build:v1beta```

#### available tags
- [```v1beta```](https://github.com/Enterprise-connect/oci/blob/v1beta/spec/build/Dockerfile), ```latest```.

#### tag usage
- ```v1beta``` refers to the image to build agent ```#1724+```-relate releases.

## agent containers
#### run example
```docker run --env-file v1beta enterpriseconnect/agent:v1beta```

#### avaialble taga
- [```v1```](https://github.com/Enterprise-connect/oci/blob/v1/spec/agent/Dockerfile), [```latest```](https://github.com/Enterprise-connect/oci/blob/v1/spec/agent/Dockerfile), [```v1-slim```](https://github.com/Enterprise-connect/oci/blob/v1/spec/agent/Dockerfile)
- ```v1-python```, ```v1-ci```
- [```v1beta```](https://github.com/Enterprise-connect/oci/blob/v1beta/spec/agent/Dockerfile), [```v1beta-slim```](https://github.com/Enterprise-connect/oci/blob/v1beta/spec/agent/Dockerfile)
- ```v1beta-python```, ```v1beta-ci```
- [```v1beta-build```](https://github.com/Enterprise-connect/oci/blob/v1beta/spec/build/Dockerfile)
- [```v1-build```](https://github.com/Enterprise-connect/oci/blob/v1/spec/build/Dockerfile)

#### Tag usage
- ```v1``` refers to agent ```#212``` release.
- ```v1beta``` include agent ```#1724``` candidate release.
- ```<tag>-build``` include the series of tool to build out an agent release.

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