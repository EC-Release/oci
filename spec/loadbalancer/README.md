![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/enterpriseconnect/loadbalancer)
## EC Gateway Load Balancer Spec
### Goal
High availability for EC gateway. Load balancing network traffic across gateway instances from multiple source and target agents in platform-agnostic way.

### Runtime Requirement
- VM's with same network group/ subnet. One VM for load balancer and rest for watchers
- OS: Linux, Windows, Darwin, Arm, etc.
- [docker 19.03.4+](https://docs.docker.com/get-docker/)   
- [EC Agent](#tag-usage)
### Design
The diagram illustrates the sequence of the connectivity model
![LB Seq. High Level](/doc/lb-sequence.png)

### How to use it

Update the environment.env file 
```shell script
GATEWAY_LIST={gatewayIP1:gatewayPort1 gatewayIP2:gatewayPort2 ..} seperated by space
DNS_NAME={Gateway DNS Name OR load balancer URL}
```

```sh
#TLS-enabled Load-Balancer
docker run -p 443:443 -p 80:80 \
--env-file=environment.env \
-v path/to/tls/cert.cr:/etc/nginx/certs/cert.crt \
-v path/to/private/key/key.key:/etc/nginx/certs/certkey.key \
enterpriseconnect/loadbalancer:v1beta

#Non-TLS Load-Balancer
docker run -p 443:443 -p 80:80 --env-file $(pwd)/environment.env enterpriseconnect/loadbalancer:v1beta
```

#### available tags
- [```v1.1beta```](https://github.com/EC-Release/oci/blob/v1beta_lber_oci_spec/spec/loadbalancer/Dockerfile)
- [```v1beta```](https://github.com/EC-Release/oci/blob/v1beta_lber_oci_spec/spec/loadbalancer/Dockerfile)
- v1.1

```sh
docker pull enterpriseconnect/loadbalancer:v1beta
```

#### tag usage
| Agent version | Load balancer image tag |
| ------------- | ----------------------- |
| [```v1```](https://github.com/EC-Release/sdk/tree/v1/dist)            | v1                    |
| [```v1beta```](https://github.com/EC-Release/sdk/tree/v1beta/dist)        | v1beta                |

### Use-case I vm-2-vm

Use case to run gateways in watcher mode in multiple virtual machines behind load balancer. Server agents make super connections with all gateway instances and client agents should able to make target systems with any available gateway instances.

![LB High Level](/doc/lb-model.png)

#### Deploy watcher in a VM

- Download the agent from [v1beta](https://github.com/EC-Release/sdk/tree/v1beta/dist/) or [v1](https://github.com/EC-Release/sdk/tree/v1/dist/)
- Prepare yml with configuration as follows - 
```yaml
ec-config:
  conf:
    mod: gateway
    gpt: "{gateway-port}"
    zon: {ec-zone-id}
    grp: {ec-service-group}
    sst: https://{ec-service-uri}
    dbg: true
    tkn: {admin-token}
    hst: ws://{loadbalancer-url-or-ip}/agent
    cps: 5
```
- Command to run watcher
```sh
./agent -cfg </path/to/yaml/file>
```

#### Run the EC gateway loadbalancer in a VM

- Update ```machine.env``` with IP address where watcher is running
- [Download and run](#how-to-use-it) the loadbalancer image
    
### Current Support Modes Matrix
Mode | Avaialble Releases | Watcher
--- | --- | ---
gateway | v1.1beta, v1.1 | Optional
client | v1.1beta, v1.1 | Optional
server | v1.1beta, v1.1 | Optional 
x:gateway | v1.1beta, v1.1 | Optional 
x:client | v1.1beta, v1.1 | Optional
x:server | v1.1beta, v1.1 | Optional
gw:server | v1.1beta, v1.1 | Optional
gw:client | v1.1beta, v1.1 | Optional

### Agent Configuration
```sh
./agent ... -hst <url/to/watcher/vm>
```
