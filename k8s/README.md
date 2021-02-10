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
$ helm create example

# REQUIRED: add the helper library as the dependency to support usage
$ helm repo add agent+helper https://ec-release.github.io/oci/agent+helper/<version. E.g. "0.1.0">

# OPTIONAL: add any of the following agent package(s) to the mychart deployment
# agent: the deployment includes the agent artifact, and the configuration
$ helm repo add agent https://ec-release.github.io/oci/agent/<version. E.g. "0.1.1">
# agent+plg: agent with plugin usage, this allow to configure plugins alongside the agent.
$ helm repo add agent+plg https://ec-release.github.io/oci/agent+plg/<version. E.g. "0.1.1">

$ helm repo list
NAME         URL
agent+helper https://ec-release.github.io/oci/agent+helper/0.1.0
agent        https://ec-release.github.io/oci/agent/0.1.3

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
...
```
```bash
# update chart repo index after modify the list
$ helm dependency update example
```
[Back to Contents](#contents)
#### Update the agent usage
In the parent chart(s), there are some options avaialble to customise the agent usage. The configuration below is also available in the example/values.yaml for the usage reference.

For plugins-relate usage in detail, please refer to the [TLS docs](https://github.com/EC-Release/sdk/tree/v1/plugins/tls), and for [VLAN docs](https://github.com/EC-Release/sdk/tree/v1/plugins/vln)
```yaml
...
global:
  agtK8Config:
    # some cluster instances require resource-spec for the deployment, e.g. GE Digital
    # PCS CF1/CF3 Cluster, whereas some can simply ignore the usage. Users may comment
    # out the "resources" section if it is not needed in your cluster.
    resources:
      limits:
        cpu: 200m
        memory: 1Gi
      requests:
        cpu: 200m
        memory: 512Mi
    svcPortNum: 18080
    svcHealthPortNum: 18081
    #options v1.1beta|v1|v1beta
    releaseTag: v1
    binaryURL: https://github.com/EC-Release/sdk/releases/agent
    # replicaCount currently supports client instances only.
    # supporting scaling gateway/server instances in k8s is in discussion.
    replicaCount: 1
    # withIngress decides the availability of the ingress obj in deployment.
    # by default, when deploy as the gateway mode (conf.mod=gateway), the value (enabled) will be overridden to true
    withIngress:
      enabled: false
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
        # The "ports" key-value pair will be overridden by the default "agtConfig" setting, if specified. E.g. "conf.rpt=<port1,port2..portn>"
        ports: [8000,8001,8002,8003]
        # The "ips" key-value pair is ignored when set "remote" to true
        ips: ["10.10.10.0/30","8.8.8.100","8.8.8.101","8.8.8.102"]
```

[Back to Contents](#contents)
#### Agent/Chart Configuration Conversion
```bash
# convert the ec config file into a chart-readable format and be ready for the chart deployment
$ cd <path/to/example> && source <(wget -O - https://ec-release.github.io/sdk/scripts/agt/v1.1beta.linux64.txt) \
-cfg <conf.yaml> \
-out <conf.env>
```
```batch
:: for windows 10+
c:\> cd <path\to\mychart> ^
&& curl -LOk https://github.com/EC-Release/sdk/raw/v1.1beta/dist/agent/agent_windows_sys.exe.tar.gz ^
&& tar xvf agent_windows_sys.exe.tar.gz ^
&& agent_windows_sys.exe -cfg -cfg <conf.yaml> -out <conf.env>
```
[Back to Contents](#contents)
#### Install Plugin & Go
```bash
# test charts template
$ helm template --set-file global.agtConfig=<conf.env> example

# deploy charts. agtConfig must present for the custom file -out
$ helm install --set-file global.agtConfig=<conf.env> --<debug|dry-run> example example/
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
[Back to Contents](#contents)
### chart developer
[Back to Contents](#contents)
### Disclaimer
<sup>Helm, Charts, and its subsidiary components are the trademark of, all right reserved by Cloud Native Compute Foundation, a Linux Foundation. Examples, plugins, chart/library packages in the sub-path of this repo are actively contributed and maintained by EC R&D team. The open source software in this subpath is licensed under [CC-By-4.0](https://creativecommons.org/licenses/by/4.0/) The software is not garanteed in a working state given any environements, ownership, and the usage may change from time-to-time depend on the project priority.</sup>

[Back to Contents](#contents)
