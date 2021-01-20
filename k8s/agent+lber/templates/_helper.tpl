{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "agentlber.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "agentlber.fullname" -}}
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
{{- define "agentlber.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "agentlber.labels" -}}
helm.sh/chart: {{ include "agentlber.chart" . }}
{{ include "agentlber.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "agentlber.selectorLabels" -}}
app.kubernetes.io/name: {{ include "agentlber.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "agentlber.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "agentlber.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}


{{/*
Generate service port spec for agent pods.
*/}}
{{- define "agentlber.svcPortSpec" -}}
- port: {{ ternary .Values.agtK8Config.svcPortNum .Values.global.agtK8Config.svcPortNum (kindIs "invalid" .Values.global.agtK8Config.svcPortNum) }}
  targetPort: {{ .Values.global.agtK8Config.portName }}
  protocol: TCP
  name: {{ .Values.global.agtK8Config.svcPortName }}
{{- end -}}

{{/*
Generate service health port spec for agent pods.
*/}}
{{- define "agentlber.svcHealthPortSpec" -}}
- port: {{ ternary .Values.agtK8Config.svcHealthPortNum .Values.global.agtK8Config.svcHealthPortNum  (kindIs "invalid" .Values.global.agtK8Config.svcHealthPortNum) }}
  targetPort: {{ .Values.global.agtK8Config.healthPortName }}
  protocol: TCP
  name: {{ .Values.global.agtK8Config.svcHealthPortName }}
{{- end -}}
