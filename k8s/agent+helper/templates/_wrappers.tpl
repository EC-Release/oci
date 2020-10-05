{{/*
   * agent plugin container wrapper
   */}}
{{- define "agent.plugins" -}}
{{- $contrName := "" -}}
{{- $contrReleaseTag := .Values.global.agtK8Config.releaseTag -}}
{{- $contrSecurityContext := .Values.global.agtK8Config.securityContext -}}
{{- if and (.Values.global.agtK8Config.withPlugins.vln.enabled) (not .Values.global.agtK8Config.withPlugins.vln.remote) -}}
{{- $contrName = .contrDictContrName -}}
{{- else -}}
{{- $contrName = include "agent.name" . -}}
{{- end -}}
- name: {{ $contrName|quote }}
  image: enterpriseconnect/plugins:{{ $contrReleaseTag }}
  command: {{ include "agent.launchCmd" . }}
  securityContext: 
    {{ toYaml $contrSecurityContext | nindent 4 }}
  imagePullPolicy: Always
  ports:
    {{- include "agent.portSpec" (merge (dict "portName" "agt-prt") .) | nindent 4 }}
    {{- include "agent.healthPortSpec" (merge (dict "portName" "agt-prt" "svcPortName" "agt-svc-prt") .) | nindent 4 }}
  livenessProbe:
    httpGet:
      path: /health
      port: {{ .Values.agtK8Config.healthPortName }}
  readinessProbe:
    httpGet:
      path: /health
      port: {{ .Values.agtK8Config.healthPortName }}
  resources:
    {{- include "agent.podResource" . | nindent 4 }}
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
    {{- include "agent.tlsPluginType" . | nindent 4 -}}
    - name: plg.tls.scm
      value: {{ .Values.global.agtK8Config.withPlugins.tls.schema|quote }}
    - name: plg.tls.hst
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
    {{- include "agent.vlnPluginType" . | nindent 4 -}}
    {{- include "vln.ports" . | nindent 4 -}}
    {{- include "vln.ips" . | nindent 4 -}}
    {{- end -}}
    {{- end -}}
{{- end -}}
