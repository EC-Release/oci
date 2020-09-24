{{/* vim: set filetype=mustache: */}}

{{/*
   * Copyright (c) 2020 General Electric Company. All rights reserved.
   *
   * The copyright to the computer software herein is the property of
   * General Electric Company. The software may be used and/or copied only
   * with the written permission of General Electric Company or in accordance
   * with the terms and conditions stipulated in the agreement/contract
   * under which the software has been supplied.
   *
   * author: apolo.yasuda@ge.com
   */}}
   

{{- define "agent.name" -}}
{{- $name_p := default $.Chart.Name $.Values.nameOverride -}}
{{- $name := ($name_p | replace "+" "-") -}}
{{- $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "agent.fullname" -}}
{{- if $.Values.fullnameOverride -}}
{{- $.Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := include "agent.name" . }}
{{- if contains $name $.Release.Name -}}
{{- $.Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" $.Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "agent.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "agent.labels" -}}
helm.sh/chart: {{ include "agent.chart" . }}
{{ include "agent.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "agent.selectorLabels" -}}
app.kubernetes.io/name: {{ include "agent.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "agent.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "agent.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Generate container port spec for client agent. Need review for gateway usage
*/}}
{{- define "agent.portSpec" -}}
{{- $mode := include "agent.mode" . -}}
{{- $portName := "lpt=" -}}
{{- if or (eq $mode "gateway") (eq $mode "gw:server") (eq $mode "gw:client") -}}
{{- $portName = "gpt=" -}}
{{- end -}}
{{- range (split "\n" .Values.global.agtConfig) -}}
{{- $a := (. | replace ":" "") -}}
{{- $b := ($a | replace "'" "") -}}
{{- $c := ($b | replace "\"" "") -}}
{{- if contains $portName $c -}}
- name: {{ printf "%s-%d" $.Values.agtK8Config.portName 0 }}
  containerPort: {{ (split "=" $c )._1 }}
  protocol: TCP
{{- else if and (contains "rpt=" $c) (or (eq $mode "gw:client") (eq $mode "client")) -}}
{{- $d := (split "rpt=" $c )._1 }}
{{- $e := 1 -}}
{{- range (split "," $d) }}
- name: {{ printf "%s-%d" $.Values.agtK8Config.portName $e }}
  containerPort: {{ . | trim }}
  protocol: TCP
{{- $e = (add $e 1) -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Generate service port spec for agent pods.
*/}}
{{- define "agent.svcPortSpec" -}}
- port: {{ ternary .Values.agtK8Config.svcPortNum .Values.global.agtK8Config.svcPortNum (kindIs "invalid" .Values.global.agtK8Config.svcPortNum) }}
  targetPort: {{ printf "%s-%d" .Values.agtK8Config.portName 0  }}
  protocol: TCP
  name: {{ printf "%s-%d" .Values.agtK8Config.svcPortName 0 }}
{{- $mode := include "agent.mode" . -}}
{{- range (split "\n" .Values.global.agtConfig) -}}
{{- $a := (. | replace ":" "") -}}
{{- $b := ($a | replace "'" "") -}}
{{- $c := ($b | replace "\"" "") -}}
{{- if and (contains "rpt=" $c) (or (eq $mode "gw:client") (eq $mode "client")) -}}
{{- $d := (split "rpt=" $c )._1 }}
{{- $e := 1 -}}
{{- range (split "," $d) }}
- port: {{ . }}
  targetPort: {{ printf "%s-%d" $.Values.agtK8Config.portName $e }}
  protocol: TCP
  name: {{ printf "%s-%d" $.Values.agtK8Config.svcPortName $e }}
{{- $e = (add $e 1) -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Generate container HEALTH port spec for client agent. Need review for gateway usage
*/}}
{{- define "agent.healthPortSpec" -}}
{{- $mode := include "agent.mode" . -}}
{{- $portName := "hca=" -}}
{{- if or (eq $mode "gateway") (eq $mode "gw:server") (eq $mode "gw:client") -}}
{{- $portName = "gpt=" -}}
{{- end -}}
{{- range (split "\n" .Values.global.agtConfig) }}
{{- if contains $portName . -}}
{{- $a := (. | replace ":" "") -}}
{{- $b := ($a | replace "'" "") -}}
{{- $c := ($b | replace "\"" "") -}}
- name: {{ $.Values.agtK8Config.healthPortName }}
  containerPort: {{ (split "=" $c )._1 }}
  protocol: TCP
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Generate service health port spec for agent pods. 
*/}}
{{- define "agent.svcHealthPortSpec" -}}
- port: {{ ternary .Values.agtK8Config.svcHealthPortNum .Values.global.agtK8Config.svcHealthPortNum  (kindIs "invalid" .Values.global.agtK8Config.svcHealthPortNum) }}
  targetPort: {{ .Values.agtK8Config.healthPortName }}
  protocol: TCP
  name: {{ .Values.agtK8Config.svcHealthPortName }}
{{- end -}}

{{/*
Specify agent launch command based on the revision from the global variable "releasetag"
*/}}
{{- define "agent.launchCmd" -}}
{{- if or (eq .Values.global.agtK8Config.releaseTag "v1.1beta") (eq .Values.global.agtK8Config.releaseTag "v1.1") -}}
["./agent","env"]
{{- else -}}
[]
{{- end -}}
{{- end -}}

{{/*
Specify the resource in the targeted cluster, if any
*/}}
{{- define "agent.podResource" -}}
{{- if .Values.global.agtK8Config.resources -}}
limits:
  cpu: {{ .Values.global.agtK8Config.resources.limits.cpu }}
  memory: {{ .Values.global.agtK8Config.resources.limits.memory }}
requests:
  cpu: {{ .Values.global.agtK8Config.resources.requests.cpu }}
  memory: {{ .Values.global.agtK8Config.resources.requests.memory }}
{{- else -}}
{}
{{- end -}}
{{- end -}}

{{/*
Extract the agent mode from the agent config
*/}}
{{- define "agent.mode" -}}
{{- range (split "\n" .Values.global.agtConfig) -}}
{{- if contains "mod=" . -}}
{{- $a := (. | replace ":" "") -}}
{{- $b := ($a | replace "'" "") -}}
{{- $c := ($b | replace "\"" "") -}}
{{- (split "=" $c )._1 -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Specify the agt ingress spec
*/}}
{{- define "agent.ingress" -}}
{{- if .Values.global.agtK8Config.withIngress.tls -}}
tls:
{{- range .Values.global.agtK8Config.withIngress.tls }}
  - hosts:
    {{- range .hosts }}
    - {{ . | quote }}
    {{- end }}
    secretName: {{ .secretName }}
{{- end -}}
{{- end }}
rules:
{{- $serviceName := include "agent.fullname" . -}}
{{- $servicePort := (ternary .Values.agtK8Config.svcPortNum .Values.global.agtK8Config.svcPortNum (kindIs "invalid" .Values.global.agtK8Config.svcPortNum)) -}}
{{- range .Values.global.agtK8Config.withIngress.hosts }}
  - host: {{ .host | quote }}
    http:
      paths:
      {{- range $path := .paths }}
        - path: {{ $path | quote }}
          backend:
            serviceName: {{ $serviceName | quote }}
            servicePort: {{ $servicePort }}
      {{- end }}
{{- end }}
{{- end -}}

{{/*
Extract the plugin flag setting (-plg) from the agent config
*/}}
{{- define "agent.hasPlugin" -}}
{{- range (split "\n" .Values.global.agtConfig) -}}
{{- if contains "plg=true" . -}}
true
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Extract the VLAN flag setting (-vln) from the agent config
*/}}
{{- define "agent.hasVLAN" -}}
{{- range (split "\n" .Values.global.agtConfig) -}}
{{- if contains "vln=true" . -}}
true
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Extract the Remote Port List flag setting (-rpt) from the agent config
*/}}
{{- define "agent.hasRPT" -}}
{{- range (split "\n" .Values.global.agtConfig) -}}
{{- if contains "rpt=" . -}}
true
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Compile the vln port list from the values.yaml and agtConfig
*/}}
{{- define "vln.ports" -}}
{{- $isRPTExists := include "agent.hasRPT" . -}}
{{- if not $isRPTExists -}}
- name: conf.rpt
{{- if eq (typeOf .Values.global.agtK8Config.withPlugins.vln.ports) "slice" -}}
  value: {{ (join "," .Values.global.agtK8Config.withPlugins.vln.ports) | quote }}
{{- else -}}
  value: "0"
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Get the vln ips list from the chart values.yaml
*/}}
{{- define "vln.ips" -}}
{{- if and (eq (typeOf .Values.global.agtK8Config.withPlugins.vln.ips) "slice") (not (eq .Values.global.agtK8Config.withPlugins.vln.remote true)) -}}
- name: plg.vln.ips
  value: {{ (join "," .Values.global.agtK8Config.withPlugins.vln.ips) | quote }}
{{- end -}}
{{- end -}}

{{/*
   * container wrapper
   */}}
{{- define "agent.plugins" -}}
- name: {{ include "agent.name" . }}
  image: "enterpriseconnect/plugins:{{ .Values.global.agtK8Config.releaseTag }}
  command: {{ include "agent.launchCmd" . }}
  securityContext:
    {{- toYaml .Values.securityContext}}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  ports:
    {{ include "agent.portSpec" . | nindent 4 }}
    {{ include "agent.healthPortSpec" . | nindent 4 }}
  livenessProbe:
    httpGet:
      path: /health
      port: {{ .Values.agtK8Config.healthPortName }}
  readinessProbe:
    httpGet:
      path: /health
      port: {{ .Values.agtK8Config.healthPortName }}
  resources:
    {{- include "agent.podResource" . }}
  env:
    {{- range (split "\n" .Values.global.agtConfig) }}
    {{- $a := splitn "=" 2 . }}
    {{- if and (not (eq $a._1 "")) ($a._1) }}
    - name: {{ $a._0|quote }}
      value: {{ $a._1|quote }}
    {{- end }}
    {{- end -}}
    {{- $mode := include "agent.mode" . -}}
    {{- $hasPlugin := include "agent.hasPlugin" . -}}
    {{- if (eq $hasPlugin "true") -}}
    {{- if and (.Values.global.agtK8Config.withPlugins.tls.enabled) (or (eq $mode "server") (eq $mode "gw:server")) }}
    - name: plg.typ
      value: tls
    - name: plg.tlc.scm
      value: {{ .Values.global.agtK8Config.withPlugins.tls.schema|quote }}
    - name: plg.tlc.hst
      value: {{ .Values.global.agtK8Config.withPlugins.tls.hostname|quote }}
    - name: plg.tls.prt
      value: {{ .Values.global.agtK8Config.withPlugins.tls.tlsport|quote }}
    - name: plg.tls.pxy
      value: {{ .Values.global.agtK8Config.withPlugins.tls.proxy|quote }}
    - name: plg.tls.lpt
      value: {{ .Values.global.agtK8Config.withPlugins.tls.port|quote }}
    - name: conf.rpt
      value: {{ include "agent.hasRPT" . }}
    {{- else if and (.Values.global.agtK8Config.withPlugins.vln.enabled) (or (eq $mode "client") (eq $mode "gw:client")) }}
    - name: plg.typ
      value: vln
    {{ include "vln.ports" . }}
    {{ include "vln.ips" . }}
    {{- end -}}
    {{- end -}}
{{- end -}}
