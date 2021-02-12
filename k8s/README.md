## EC Connectivity in kubernetes
agent k8s deployment via helmchart examples.

### Contents
* [Use Case PoC](#use-case-poc) 
* [Requirement](#requirement) 
* [Getting Started](#getting-started)
  * [Add Dependency Repo](#add-dependency-repo)
  * [Update Dependency List](#update-dependency-list)
  * [Agent/Chart Configuration Conversion](#agentchart-configuration-conversion)
  * [Install Plugin & Go](#install-plugin--go)
* [chart developer](#chart-developer)
* [Disclaimer](#disclaimer)

### Use Case PoC
The diagram illustrates the usage of the connectivity model in k8s
![LB Seq. High Level](/doc/k8s-ftp.png)

### Requirement
- [helm 3.0+](https://helm.sh/docs/intro/install/)
- [kubectl 1.10+](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

### Getting Started

#### Add Dependency Repo
```bash
# bootstrap a chart
$ helm create example -n namespace

# REQUIRED: add the helper library as the dependency to support usage
$ helm repo add agent+helper https://ec-release.github.io/oci/agent+helper/<version. E.g. "0.1.0"> -n namespace

# OPTIONAL: add any of the following agent package(s) to the mychart deployment
# agent: the deployment includes the agent artifact, and the configuration
$ helm repo add agent https://ec-release.github.io/oci/agent/<version. E.g. "0.1.1"> -n namespace
# agent+plg: agent with plugin usage, this allow to configure plugins alongside the agent.
$ helm repo add agent+plg https://ec-release.github.io/oci/agent+plg/<version. E.g. "0.1.1"> -n namespace
# agentlber: agent with loadbalncer usage, this allow to deploy agent with load balancer.
$ helm repo add agentlber https://ec-release.github.io/oci/agentlber/<version. E.g. "0.1.0"> -n namespace

$ helm repo list -n namespace
NAME         URL
agent+helper https://ec-release.github.io/oci/agent+helper/0.1.0
agent        https://ec-release.github.io/oci/agent/0.1.3
agentlber    https://ec-release.github.io/oci/agentlber/0.1.0

```
[Back to Contents](#contents)
#### Update Dependency List
```yaml
# add chart dependencies to example/Chart.yaml
dependencies:
# REQUIRED
- name: agent+helper
  version: 0.1.0
  repository: "@agent+helper"
# OPTIONAL
- name: agent
  version: 0.1.1
  repository: "@agent"
# OPTIONAL
- name: agent+plg
  version: 0.1.1
  repository: "@agent+plg"
# OPTIONAL
- name: agentlber
  version: 0.1.0
  repository: "@agentlber"
...
```
```bash
# update chart repo index after modify the list
$ helm dependency update example -n namespace
```
[Back to Contents](#contents)
#### Update the agent usage
In the parent chart(s), there are some options avaialble to customise the agent usage. The configuration below is also available in the example/values.yaml for the usage reference.

For plugins-relate usage in detail, please refer to the [TLS docs](https://github.com/EC-Release/sdk/tree/v1/plugins/tls), and for [VLAN docs](https://github.com/EC-Release/sdk/tree/v1/plugins/vln)

Please refer [page](https://gitlab.com/digital-fo/connectivity/enterprise-connect/platform-agnostic/agent/-/tree/v1/example-yml) to get the subset of agent flags based on mod
```yaml
...
global:
  agtConfig:
    conf.mod=gateway|server|client|gw:server|gw:client
    conf.gpt=global port in number
    conf.dbg=boolean true|false
    conf.hst="ws|wss://gateway-url/agent"
    conf.tkn=ec-service-admin-token
    conf.cps=number
    conf.zon=predix-zone-id
    conf.grp=ec-group-name
    conf.sst=https://predix-zone-id.run.aws-usw02-pr|dev.ice.predix.io
    conf.cid=uaa-client-id
    conf.csc=uaa-client-secret
    conf.oa2=https://uaa-authentication-url/oauth/token
    conf.dur=number in seconds
    conf.aid=agent-id
    conf.rpt=target-port-number
    conf.rht=target-host
    conf.plg=true|false
    conf.tid=target-agent-id
    conf.lpt=local-listening-port-number
    conf.hca=agent-health-port-number
    conf.pxy="org-proxy-url"
    AGENT_REV=agent-release-version
    EC_PPS=admin-hash
  agtK8Config:
    # some cluster instances require resource-spec for the deployment, e.g. GE Digital
    # PCS CF1/CF3 Cluster, whereas some can simply ignore the usage.
    resources:
      limits:
        cpu: 200m
        memory: 512Mi
      requests:
        cpu: 100m
        memory: 128Mi
    svcPortNum: 8080
    svcHealthPortNum: 8081
    # Following properties related to load balancer
    # statefulset fields are optional for deploying agent alone.. mandatory for agent with load balancer
    stsName: ram-app-agent
    lberReplicaCount: 1
    lberContainerPortNum: 8080
    lberContainerHealthPortNum: 8080
    lberSvcPortNum: 18090
    lberSvcHealthPortNum: 18091
    # options v1.1beta|v1|v1beta
    releaseTag: v1
    # specify an agent revision in the container runtime
    agentRev: v1.hokkaido.213
    binaryURL: https://github.com/EC-Release/sdk/releases/agent
    # replicaCount currently supports client instances only.
    # supporting scaling gateway/server instances in k8s is in discussion.
    replicaCount: 2
    # withIngress decides the availability of the agt ingress obj in deployment.
    # by default, when deploy as the gateway mode (conf.mod=gateway), the value (enabled) will be overridden to true
    withIngress:
      enabled: true
      # host utilised to make the agt accessible via non-tls traffic. 
      # it is also possible for the co-existence and the overlap of both tls/non-tls routings (hosts/tls)
      hosts:
        - host: ec.http.helloworld.ge.com
          paths: ["/agent", "/health", "/v1", "/v1beta"]
      # present if the agt is accessible via wss|https
      tls:
        - secretName: tls-secret-1
          hosts: ["ec.helloworld.ge.com", "ec.rel.ge.com"]
        - secretName: tls.secret-2
          hosts: ["*.ec.https.ge.com", "ec.dev.azure.com"]
    # options below are applicable only in the agent+plugins helm package. 
    # this setting is intended to deploy a plugin alongside the agent when "-plg" is present or is "true"
    withPlugins:
      # the tls setting only valid when agent mode "-mod" is either "server" or "gw:server"
      tls:
        enabled: false
        schema: https 
        hostname: twitter.com
        tlsport: 443
        proxy: http://traffic-manipulation.job.security.io:8080
        port: 17990
      # the vln setting only valid when agent mode "-mod" is either "client" or "gw:client"
      vln:
        # The "enabled" key-value pair will be overridden by the "agtConfig" setting, if specified. E.g. "conf.vln=true"
        enabled: true
        # the "remote" key-value pair indicates the vlan deployment strategy. When default to true,
        # the vlan setup will ignore the "ips" setting, and instead simulate only the "ports"-
        # setting via a series of service/pod remote to the client application. In the remote-
        # scenario, it is subject to the client app's configuration in its respective pod in order-
        # to make the "ips" setting work correcly. Otherwise the setup will deploy the plugin artifact-
        # along with the ips/ports setting, and assume the direct interaction with the local loopback-
        # interface at the parental pod.
        remote: false
        # customise the securityContext when the vln plugin launched in a multi-contr pod (remote: false)
        securityContext:
          # map the container runner to an internal user. E.g. uid: 1000
          runAsUser: 0
          # deny a potential privilege escalation request
          allowPrivilegeEscalation: false
          privileged: false
        # The "ports" keypair will be overridden by the default "agtConfig" setting, if specified. E.g. "conf.rpt=<port1,port2..portn>"
        ports: [8000,8001,8002,8003]
        # The "ips" keypair is ignored when set "remote" to true
        ips: ["10.10.10.0/30","8.8.8.100","8.8.8.101","8.8.8.102"]
```

[Back to Contents](#contents)
#### Install Plugin & Go
```bash
# test charts template
$ helm template example -n namespace

# deploy charts
$ helm install --<debug|dry-run> example example/ -n namespace
# Source: example/charts/agent/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: RELEASE-NAME-agent
  labels:
    helm.sh/chart: agent-0.1.0
    app.kubernetes.io/name: agent
    app.kubernetes.io/instance: RELEASE-NAME
    app.kubernetes.io/version: "v1.1beta"
    app.kubernetes.io/managed-by: Helm
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: agent
      app.kubernetes.io/instance: RELEASE-NAME
  template:
    metadata:
      labels:
        app.kubernetes.io/name: agent
        app.kubernetes.io/instance: RELEASE-NAME
    spec:
      serviceAccountName: RELEASE-NAME-agent
      securityContext:
        {}
      containers:
        - name: agent
          image: enterpriseconnect/agent:v1.1beta
          command: ["./agent", "-env"] 
          securityContext:
            {}
          image: "enterpriseconnect/agent:v1.1beta"
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
          livenessProbe:
            httpGet:
              path: /
              port: http
          readinessProbe:
            httpGet:
              path: /
              port: http
          resources:
            {}
          env:
            - name: "mod"
              value: "client"
            - name: "lpt"
              value: "7990"
            - name: "cid"
              value: "hello"
            - name: "csc"
              value: "DWDdfddfs@"
            - name: "aid"
              value: "31fwe"
            - name: "tid"
              value: "f3f3rv"
---

HOOKS:
---
# Source: agent/templates/tests/test-connection.yaml
apiVersion: v1
kind: Pod
metadata:
  name: "mydemo-agent-test-connection"
  labels:
    helm.sh/chart: agent-0.1.0
    app.kubernetes.io/name: agent
    app.kubernetes.io/instance: mydemo
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
  annotations:
    "helm.sh/hook": test-success
spec:
  containers:
    - name: wget
      image: busybox
      command: ['wget']
      args: ['mydemo-agent:80']
  restartPolicy: Never
MANIFEST:
...
```

#### Parametes

EC configuration parameters - `global.agtConfig`

| Parameter             | Description                           | Allowed values                            |
| --------------------- | ------------------------------------- | ---------------------------------------   | 
| `conf.mod`            | Agent mode                            | gateway/server/client/gw:server/gw:client |
| `conf.gpt`            | global port                           | number                                    |
| `conf.dbg`            | enable debug                          | boolean true/false                        |
| `conf.hst`            | gateway url in quotes                 | "wss://gateway-url/agent"                 |
| `conf.tkn`            | EC service admin token                |                                           |
| `conf.cps`            |                                       | number                                    |
| `conf.zon`            | Predix zone id                        |                                           |
| `conf.grp`            | EC group name                         |                                           |
| `conf.sst`            | EC Service URI                        | https://predix-zone-id.run.aws-usw02-pr[dev].ice.predix.io |
| `conf.cid`            | uaa-client-id                         |                                           |
| `conf.csc`            | uaa-client-secret                     |                                           |
| `conf.oa2`            | Authentication URL                    | https://uaa-authentication-url/oauth/token|
| `conf.dur`            | oAuth token validation time           | number in seconds                         |
| `conf.aid`            | Agent Id                              |                                           |
| `conf.rpt`            | Target port number                    |                                           |
| `conf.rht`            | Target host/IP                        |                                           |
| `conf.plg`            | Enable plugins                        | true/false                                |
| `conf.tid`            | Target agent Id                       |                                           |
| `conf.lpt`            | Local listening port number           |                                           |
| `conf.hca`            | Agent health port number              |                                           |
| `conf.pxy`            | Org proxy URL in quotes               | "org-proxy-url"                           |
| `AGENT_REV`           | Agent release version                 |                                           |
| `EC_PPS`              | admin-hash                            |                                           |
| `AGENT_REPLICA_COUNT` | #HIDDEN# Agent replica count          |                                           |
| `VCAP_APPLICATION`    | #HIDDEN# CF VCAP properties           |                                           |
| `AGENT_ENV`           | #HIDDEN# Property where agent running | `k8s` for EKS                             |

Agent parameters - `global.agtK8Config`

| Parameter                                                  | Description                               | Allowed values |
| ---------------------------------------------------------- | ----------------------------------------- | -------------- |
| `svcPortNum`                                               | Service/headless service port num         | number         |
| `svcHealthPortNum`                                         | Service/headless service health port      | number         |
| `agentRev`                                                 | Agent version                             |                |

Agent Parameters - TLS Plugin - `global.agtK8Config.tls`

| Parameter                                                  | Description                               | Allowed values |
| ---------------------------------------------------------- | ----------------------------------------- | -------------- |
| `withPlugins.tls.enabled`                                  | Enable TLS plugin                         | boolean        |
| `withPlugins.tls.schema`                                   | Protocol                                  |                |
| `withPlugins.tls.hostname`                                 | Host or resource to connect               |                |
| `withPlugins.tls.tlsport`                                  | Host or resource port                     |                |
| `withPlugins.tls.proxy`                                    | Proxy (if any) to connect to remote resource |             |
| `withPlugins.tls.port`                                     | Port EC agent listening to                | number         |

Agent Parameters - VLAN Plugin - `global.agtK8Config.vln`

| Parameter                                                  | Description                               | Allowed values |
| ---------------------------------------------------------- | ----------------------------------------- | -------------- |
| `withPlugins.vln.enabled`                                  | Enable VLAN plugin                        | number         |
| `withPlugins.vln.remote`                                   |                                           | boolean        |
| `withPlugins.vln.securityContext.runAsUser`                | User name for connecting to remote resource |              |
| `withPlugins.vln.securityContext.allowPrivilegeEscalation` |                                           |                |
| `withPlugins.vln.securityContext.privileged`               |                                           |                |
| `withPlugins.vln.ports`                                    | Target system ports in array              |                |
| `withPlugins.vln.ips`                                      | Target system hosts/ips in array          |                |

Ingress parameters - `global.agtK8Config.withIngress`

| Parameter        | Description                                           | Allowed values |
| ---------------- | ----------------------------------------------------- | -------------- |
| `enabled`        | Enable Ingress component                              | boolean        |
| `hosts.host`     | Ingress URL or DNS name assigned to Ingress component |                |
| `hosts.paths`    | End point paths                                       |                |
| `tls.secretName` |                                                       |                |
| `tls.hosts`      |                                                       |                |


[Back to Contents](#contents)
### chart developer
[Back to Contents](#contents)
### Disclaimer
<sup>Helm, Charts, and its subsidiary components are the trademark of, all right reserved by Cloud Native Compute Foundation, a Linux Foundation. Examples, plugins, chart/library packages in the sub-path of this repo are actively contributed and maintained by EC R&D team. The open source software in this subpath is licensed under [CC-By-4.0](https://creativecommons.org/licenses/by/4.0/) The software is not garanteed in a working state given any environements, ownership, and the usage may change from time-to-time depend on the project priority.</sup>

[Back to Contents](#contents)
