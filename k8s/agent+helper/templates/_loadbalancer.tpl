{{- define "agent.loadbalancer" -}}
{{ $upstreamstr := "\n" }}
{{ $masterupstream := "upstream master { " }}
{{- range $index := until (int $.Values.global.agtK8Config.replicaCount) }}
upstream app{{ $index }} {
  server {{ $.Values.global.agtK8Config.stsName }}-{{ $index }}.{{ $.Values.global.agtK8Config.stsName }}.{{ $.Release.Namespace }}.svc.cluster.local:7990;
}
{{- end }}
upstream master {
  {{- range $index := until (int $.Values.global.agtK8Config.replicaCount) }}
  server {{ $.Values.global.agtK8Config.stsName }}-{{ $index }}.{{ $.Values.global.agtK8Config.stsName }}.{{ $.Release.Namespace }}.svc.cluster.local:7990;
  {{- end }}
}
map $http_X_CF_APP_INSTANCE $pool {
  default "master";
  {{- range $index := until (int $.Values.global.agtK8Config.replicaCount) }}
  ~*.*:{{ $index }}$ "app{{ $index }}";
  {{- end }}
}
{{- end -}}


{{- define "agent.cfenv" -}}
{{- range (split "\n" .Values.global.agtConfig) }}
{{- $a := splitn "=" 2 . }}
{{- if and (not (eq $a._1 "")) ($a._1) (eq $a._0 "conf.zon") -}}
- name: Px-Zone-Id
  value: {{ $a._1|quote }}
{{- end -}}
{{- end }}
- name: AGENT_REPLICA_COUNT
  value: {{ .Values.global.agtK8Config.replicaCount | quote }}
- name: IS_EKS_ENV
  value: "true"
{{- end -}}


{{- define "agent.host" -}}
{{- range $index, $hosts := .Values.global.agtK8Config.withIngress.hosts }}
{{- if (eq $index 0) }}
  {{- .host | quote }}
{{- end }}
{{- end }}
{{- end -}}