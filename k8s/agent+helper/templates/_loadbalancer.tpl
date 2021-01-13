{{- define "agent.loadbalancer" -}}
{{- $upstreamstr := "" -}}
{{- $masterupstream := "upstream master { " -}}

{{- range $index := until (int $.Values.global.agtK8Config.stsReplicaCount) -}}
{{- printf "upstream app{{ $index }} {" -}}
{{- printf "  server {{ $.Values.ecStsName }}-{{ $index }}.{{ $.Release.Namespace }}.svc.cluster.local:80; " -}}
{{- printf "}" -}}
{{- end -}}
{{- printf "upstream master {" -}}

{{- end -}}