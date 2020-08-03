{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "agent.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "agent.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
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
{{- range (split "\n" .Values.global.agtConfig) }}
{{- if contains "lpt=" . -}}
{{- $a := (. | replace ":" "") -}}
{{- $b := ($a | replace "'" "") -}}
{{- $c := ($b | replace "\"" "") -}}
- name: {{ $.Values.agtK8Config.portName }}
  containerPort: {{ (split "=" $c )._1 }}
  protocol: TCP
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Generate service port spec for client agent pods. Need review for gateway usage
*/}}
{{- define "agent.svcPortSpec" -}}
- port: {{ ternary .Values.agtK8Config.svcPortNum .Values.global.agtK8Config.svcPortNum (kindIs "invalid" .Values.global.agtK8Config.svcPortNum) }}
  targetPort: {{ .Values.agtK8Config.portName }}
  protocol: TCP
  name: {{ .Values.agtK8Config.svcPortName }}
{{- end -}}

{{/*
Generate container HEALTH port spec for client agent. Need review for gateway usage
*/}}
{{- define "agent.healthPortSpec" -}}
{{- range (split "\n" .Values.global.agtConfig) }}
{{- if contains "hca=" . -}}
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
Generate service health port spec for client agent pods. Need review for gateway usage
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
  tls:
  {{- range .Values.global.agtK8Config.withIngress.tls }}
    - hosts:
      {{- range .hosts }}
        - {{ . | quote }}
      {{- end }}
      secretName: {{ .secretName }}
  {{- end }}
  rules:
  {{- range .Values.global.agtK8Config.withIngress.hosts }}
    - host: {{ .host | quote }}
      http:
        paths:
        {{- range .paths }}
          - path: {{ . }}
            backend:
              serviceName: {{- include "agent.fullname" -}}
              servicePort: {{ ternary .Values.agtK8Config.svcPortNum .Values.global.agtK8Config.svcPortNum (kindIs "invalid" .Values.global.agtK8Config.svcPortNum) }}
        {{- end }}
  {{- end }}
{{- end -}}
