## EC Connectivity in kubernetes
agent k8s deployment via helmchart examples.

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
$ helm repo add agent+helper https://ec-release.github.io//oci/agent+helper/<version. E.g. "0.1.0">

# OPTIONAL: add any of the following agent package(s) to the mychart deployment
# agent: the deployment includes the agent artifact, and the configuration
$ helm repo add agent https://ec-release.github.io/oci/agent/<version. E.g. "0.1.1">
# agent+vln: agent with vlan usage, this allow the vln 
# plugin to control the vlan setting inside the container.
$ helm repo add agent+vln https://ec-release.github.io/oci/agent+vln/<version. E.g. "0.1.0">
# agent+tls: agent with tls usage. tls can be served as a reversed-proxy to
# bypass a tls security restriction.
$ helm repo add agent+tls https://ec-release.github.io/oci/agent+tls/<version. E.g. "0.1.0">

$ helm repo list
NAME         URL
agent+helper https://ec-release.github.io/oci/agent+helper/0.1.0
agent        https://ec-release.github.io/oci/agent/0.1.3

```
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
- name: agent+vln
  version: 0.1.0
  repository: "@agent+vln"
...
```
```bash
# update chart repo index after modify the list
$ helm dependency update example
```

#### Update the agent usage
In the parent chart(s), there are some options avaialble to customise the agent usage. The configuration below is also available in the example/values.yaml for the usage reference.
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

```

#### Agent/Chart Configuration Conversion
```bash
# convert the ec config file into a chart-readable format and be ready for the chart deployment
$ cd <path/to/example> && source <(wget -O - https://enterprise-connect.github.io/sdk/scripts/agt/v1.1beta.linux64.txt) \
-cfg <conf.yaml> \
-out <conf.env>
```
```batch
:: for windows 10+
c:\> cd <path\to\mychart> ^
&& curl -LOk https://github.com/Enterprise-connect/sdk/raw/v1.1beta/dist/agent/agent_windows_sys.exe.tar.gz ^
&& tar xvf agent_windows_sys.exe.tar.gz ^
&& agent_windows_sys.exe -cfg -cfg <conf.yaml> -out <conf.env>
```
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

### chart developer

### Disclaimer
<sup>Helm, Charts, and its subsidiary components are the trademark of, all right reserved by Cloud Native Compute Foundation, a Linux Foundation. Examples, plugins, chart/library packages in the sub-path of this repo are actively contributed and maintained by EC R&D team. The open source software in this subpath is licensed under [CC-By-4.0](https://creativecommons.org/licenses/by/4.0/) The software is not garanteed in a working state given any environements, ownership, and the usage may change from time-to-time depend on the project priority.</sup>
