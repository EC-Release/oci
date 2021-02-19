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
run: {{ include "agentlber.fullname" . }}
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
- port: 18090
  targetPort: lb-prt-name
  protocol: TCP
  name: lb-svc-prt
{{- end -}}

{{/*
Generate service health port spec for agent pods.
*/}}
{{- define "agentlber.svcHealthPortSpec" -}}
- port: 18091
  targetPort: lb-h-prt-name
  protocol: TCP
  name: lb-svc-h-prt
{{- end -}}


{{/*
Generate container port spec for client agent. Need review for gateway usage
*/}}
{{- define "agentlber.portSpec" -}}
- name: lb-prt-name
  containerPort: 8080
  protocol: TCP
{{- end -}}


{{/*
Generate container HEALTH port spec for client agent. Need review for gateway usage
*/}}
{{- define "agentlber.healthPortSpec" -}}
- name: lb-h-prt-name
  containerPort: 8080
  protocol: TCP
{{- end -}}


{{/*
Specify the agt ingress spec
*/}}
{{- define "agentlber.ingress" -}}
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
{{- $servicePort := 18090 -}}
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