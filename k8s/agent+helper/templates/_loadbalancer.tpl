{{- define "agent.loadbalancer" -}}
{{ $upstreamstr := "\n" }}
{{ $masterupstream := "upstream master { " }}
{{- range $index := until (int $.Values.global.agtK8Config.stsReplicaCount) }}
upstream app{{ $index }} {
  server {{ $.Values.global.agtK8Config.stsName }}-{{ $index }}.{{ $.Release.Namespace }}.svc.cluster.local:80;
}
{{- end }}
upstream master {
  {{- range $index := until (int $.Values.global.agtK8Config.stsReplicaCount) }}
  server {{ $.Values.global.agtK8Config.stsName }}-{{ $index }}.{{ $.Release.Namespace }}.svc.cluster.local:80;
  {{- end }}
}
map $http_CF_INSTANCE_INDEX $pool {
  default "master";
  {{- range $index := until (int $.Values.global.agtK8Config.stsReplicaCount) }}
  app{{ $index }} "app{{ $index }}";
  {{- end }}
}
{{- end -}}