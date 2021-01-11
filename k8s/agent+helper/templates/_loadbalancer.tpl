{{- define "agent.loadbalancer" -}}
{{ $upstreamstr := "\n" }}
{{ $masterupstream := "upstream master { " }}

{{- range $index := until (int $.Values.global.agtK8Config.replicaCount) }}
upstream app{{ $index }} {
  server {{ $.Values.ecStsName }}-{{ $index }}.{{ $.Release.Namespace }}.svc.cluster.local:80;
}
{{- end }}

upstream master {
  {{- range $index := until (int $.Values.ecStsReplicaCount) }}
  server {{ $.Values.ecStsName }}-{{ $index }}.{{ $.Release.Namespace }}.svc.cluster.local:80;
  {{- end }}
}

map $http_CF_INSTANCE_INDEX $pool {
  default "master";
  {{- range $index := until (int $.Values.ecStsReplicaCount) }}
  app{{ $index }} app{{ $index }};
  {{- end }}
}

{{- end }}