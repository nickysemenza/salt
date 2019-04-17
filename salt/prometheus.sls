include:
  - cloudflared

group_prometheus:
  group:
    - present
    - name: prometheus
    - system: True

user_prometheus:
  user:
    - present
    - name: prometheus
    - groups:
      - prometheus
    - home: /srv/prometheus
    - createhome: True
    - shell: /bin/false
    - system: True

{% set port = pillar.get('ports')['node_exporter'] %}

{% load_yaml as opts %}
- web.listen-address=":{{port}}"
- collector.processes 
- collector.systemd

{% endload %}


{%- set node_exporter_version = '0.17.0' %}
{%- set node_exporter_name = 'node_exporter-'+node_exporter_version+'.linux-'+grains.get('osarch') %}
{%- set dir = '/srv/prometheus/node_exporter/'+node_exporter_name %}
{%- set cmd = dir+'/node_exporter' + opts | map('replace', '', ' --', 1) | join %}


{% if not salt['file.directory_exists' ](dir) %}
prometheus_node_exporter_archive:
  archive:
    - extracted
    - name: /srv/prometheus/node_exporter
    - source: https://github.com/prometheus/node_exporter/releases/download/v{{node_exporter_version}}/{{node_exporter_name}}.tar.gz
    - skip_verify: True
    - user: prometheus
    - group: prometheus
    - keep: True #}
{% endif %}
{# https://www.lutro.me/posts/managing-systemd-units-with-salt #}
prometheus_node_exporter_service_script:
  file:
    - managed
    - name: /etc/systemd/system/prometheus-node_exporter.service
    {# TODO: don't hardcode root #}
    - user: root
    - group: root
    - contents: |
        [Unit]
        Description=prometheus
        After=syslog.target network.target

        [Service]
        Type=simple
        RemainAfterExit=no
        WorkingDirectory= {{dir}}
        User=prometheus
        Group=prometheus
        ExecStart={{cmd}} 

        [Install]
        WantedBy=multi-user.target
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: /etc/systemd/system/prometheus-node_exporter.service

prometheus_node_exporter_service:
  service:
    - running
    - name: prometheus-node_exporter
    - enable: True
    - watch: 
      - module: prometheus_node_exporter_service_script

{%- from 'cloudflared/init.sls' import spawn_cloudflared %}
{{ spawn_cloudflared('nickysemenza.com', 'salttest1.nickysemenza.com', pillar.ports['node_exporter'], 'localhost') }}