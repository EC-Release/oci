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
```sh
#TLS-enabled Load-Balancer
docker run \
-v path/to/tls/cert.crt:/etc/nginx/certs/cert.crt \
-v path/to/private/key/key.key:/etc/nginx/certs/certkey.key \
--env-file $(pwd)/environment.env \
-p 8080:80 \
enterpriseconnect/loadbalancer:v1.1beta

#Non-TLS Load-Balancer
docker run -p 8080:80 --env-file $(pwd)/environment.env enterpriseconnect/loadbalancer:v1.1beta
```

#### available tags
- [```v1.1beta```](https://github.com/Enterprise-connect/oci/blob/v1.1beta/spec/loadbalancer/Dockerfile)
- v1.1

```sh
docker pull enterpriseconnect/loadbalancer:v1.1beta
```

#### tag usage
| Agent version | Load balancer image tag |
| ------------- | ----------------------- |
| [```v1.1```](https://github.com/Enterprise-connect/sdk/tree/v1.1/dist/agent) | v1.1                    |
| [```v1```](https://github.com/Enterprise-connect/sdk/tree/v1/dist)            | v1.1                    |
| [```v1.1beta```](https://github.com/Enterprise-connect/sdk/tree/v1.1beta/dist/agent)      | v1.1beta                |
| [```v1.1```](https://github.com/Enterprise-connect/sdk/tree/v1beta/dist)        | v1.1beta                |

### Use-case I vm-2-vm

Use case to run gateways in watcher mode in multiple virtual machines behind load balancer. Server agents make super connections with all gateway instances and client agents should able to make target systems with any available gateway instances.

![LB High Level](/doc/lb-model.png)

#### Deploy watcher in a VM

- Download the agent from [v1.1beta](https://github.com/Enterprise-connect/sdk/tree/v1.1beta/dist/agent) or [v1.1](https://github.com/Enterprise-connect/sdk/tree/v1.1/dist/agent)
- Prepare yml with configuration as follows - 
```yaml
ec-config:
  conf:
    mod: gateway
    gpt: ":17990"
    zon: {ec-zone-id}
    grp: {ec-service-group}
    sst: https://{ec-service-uri}
    dbg: true
    tkn: {admin-token}
    hst: ws://{loadbalancer-url-or-ip}/agent
    cps: 5
  watcher:
    env: LOCAL
    license: SERVER_X5 #cert
    role: DEVELOPER #cert
    devId: {developer-id}
    scope: app.auth #cert
    certsDir: "/etc/ssl/certs"
    mode: gateway #cert. available option: gateway,server,client,gw:server,gw:client
    os: linux
    arch: amd64
    instance: 1
    duration: 1
    cpuPeriod: 100000 #microsec. e.g. 50000/100000 = .5 cpu
    cpuQuota: 50000
    cpuShared: 128
    inMemory: 134217728 #in bytes. ~128mb
    swapMemory: 134217728
    oauth2: https://ec-oauth.herokuapps.com
    httpPort: ":17990"
    tcpPort: ":17991"
    customPort: ":17992"
    contRev: {agent-version}
    contArtURL: https://raw.githubusercontent.com/Enterprise-connect/sdk/{{contRev}}/dist/agent/agent_linux_sys.tar.gz
```
- Command to run watcher
```sh
./agent -cfg </path/to/yaml/file> -wtr 
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
