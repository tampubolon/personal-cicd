{{/* File: golang-chart/templates/_helpers.tpl */}}

{{/* Generate a full name for resources by concatenating release name and chart name */}}
{{- define "golang-chart.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name -}}
{{- end -}}