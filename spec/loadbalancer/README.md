## EC Load Balancer Spec
### Design
The diagram illustrates the sequence of the connectivity model
![LB Seq. High Level](/doc/lb-sequence.png)


Overall connectivity model for the LBer.
![LB High Level](/doc/lb-model.png)



### How to use it
```sh
#TLS-enabled Load-Balancer
docker run \
-v path/to/tls/cert.pem:~/cert.pem \
-v path/to/private/key/key.pem:~/key.pem \
-p 8080:80 \
enterpriseconnect/loadbalancer:v1.1beta

#Non-TLS Load-Balancer
docker run -p 8080:80 --env-file $(pwd)/machine.env enterpriseconnect/loadbalancer:v1.1beta
```

### Use-case I vm-2-vm
![LB Usecase](/doc/lb-usecase.png)


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

Download the agent and run gateway - 
```sh
./agent -cfg </path/to/yaml/file> -wtr 
```

Note: ```wtr``` falg is to run gateway in watcher mode. Gateway can also run as standalone process.

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
