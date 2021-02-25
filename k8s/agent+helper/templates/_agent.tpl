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
   * author: ec-research@ge.com
   */}}

{{/*
Generate service port spec for agent pods.
*/}}
{{- define "agent.svcPortSpec" -}}
- port: {{ ternary .Values.agtK8Config.svcPortNum .Values.global.agtK8Config.svcPortNum (kindIs "invalid" .Values.global.agtK8Config.svcPortNum) }}
  targetPort: agt-prt
  protocol: TCP
  name: agt-svc-prt
{{- end -}}


{{/*
Generate service health port spec for agent pods.
*/}}
{{- define "agent.svcHealthPortSpec" -}}
- port: {{ ternary .Values.agtK8Config.svcHealthPortNum .Values.global.agtK8Config.svcHealthPortNum  (kindIs "invalid" .Values.global.agtK8Config.svcHealthPortNum) }}
  targetPort: agt-h-prt
  protocol: TCP
  name: agt-svc-h-prt
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
{{- range (split "\n" .Values.global.agtConfig) }}
{{- if contains $portName . -}}
{{- $a := (. | replace ":" "") -}}
{{- $b := ($a | replace "'" "") -}}
{{- $c := ($b | replace "\"" "") -}}
- name: agt-prt
  containerPort: {{ (split "=" $c )._1 }}
  protocol: TCP
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Generate container HEALTH port spec for client agent. Need review for gateway usage
*/}}
{{- define "agent.healthPortSpec" -}}
{{- $mode := include "agent.mode" . -}}
{{- $portName := "hca=" -}}
{{- if or (eq $mode "gateway") (eq $mode "gwserver") (eq $mode "gwclient") -}}
{{- $portName = "gpt=" -}}
{{- end -}}
{{- range (split "\n" .Values.global.agtConfig) }}
{{- if contains $portName . -}}
{{- $a := (. | replace ":" "") -}}
{{- $b := ($a | replace "'" "") -}}
{{- $c := ($b | replace "\"" "") -}}
- name: agt-h-prt
  containerPort: {{ (split "=" $c )._1 }}
  protocol: TCP
{{- end -}}
{{- end -}}
{{- end -}}


{{- define "agent.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Selector labels
*/}}
{{- define "agent.selectorLabels" -}}
app.kubernetes.io/name: agent
app.kubernetes.io/instance: {{ .Release.Name }}
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
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "agent.fullname" -}}
{{- if $.Values.fullnameOverride -}}
{{- $.Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default $.Chart.Name $.Values.nameOverride -}}
{{- if contains $name $.Release.Name -}}
{{- $.Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" $.Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "agent.chart" -}}
{{- printf "agent-%s" .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
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