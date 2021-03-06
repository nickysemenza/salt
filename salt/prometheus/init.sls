
{%- set node_exporter_version = '1.0.0-rc.0' %}
{%- set prom_version = '2.18.1' %}

{% set host = grains.get('host') %}
{% set node_configs = pillar.get('prometheus') %}
{% set node_proms = node_configs[host] if host in node_configs else None %}

{% set run_server = True if node_proms and node_proms.scrape_configs else False %}

{% set dir = '/data/prometheus' %}
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
    {# - home: {{ dir }} #}
    {# - createhome: True #}
    - shell: /bin/false
    - system: True

{% set node_exporter_port = pillar.get('ports')['node_exporter'] %}
{# {% set _port = pillar.get('ports')['node_exporter'] %} #}

{% load_yaml as node_exporter_opts %}
- web.listen-address=":{{node_exporter_port}}"
- collector.processes 
- collector.systemd
- collector.wifi
- collector.textfile.directory="{{ dir }}/text"
{% endload %}

{% load_yaml as prom_opts %}
- web.listen-address=":{{pillar.get('ports')['prometheus']}}"
- config.file="{{ dir }}/prometheus.yml"
- storage.tsdb.retention.time="5d"
{% endload %}

{%- set arch = grains.get('osarch')%}
{% if grains.get('cpuarch') == "armv7l" %}
  {%- set arch = "armv7" %} 
{% endif %}



{%- set prom_name = 'prometheus-'+prom_version+'.linux-'+arch %}
{%- set prom_dir = dir+'/prometheus/'+prom_name %}
{%- set prom_cmd = prom_dir+'/prometheus' + prom_opts | map('replace', '', ' --', 1) | join %}

{% if run_server %}
{{ dir }}/prometheus.yml:
  file.managed:
    - source: salt://prometheus/prometheus.yml.jinja
    - template: jinja
    - mode: 644
    - user: prometheus
    - group: prometheus
    - context:
        scrape_configs: {{node_proms['scrape_configs']}}
{% endif %}


{% if not salt['file.directory_exists' ](prom_dir) %}
prometheus_archive:
  archive:
    - extracted
    - name: {{ dir }}/prometheus
    - source: https://github.com/prometheus/prometheus/releases/download/v{{prom_version}}/{{prom_name}}.tar.gz
    - skip_verify: True
    - user: prometheus
    - group: prometheus
    - keep: True #}
{% endif %}

{# https://www.lutro.me/posts/managing-systemd-units-with-salt #}
prometheus_service_script:
  file:
    - managed
    - name: /etc/systemd/system/prometheus.service
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
        WorkingDirectory= {{prom_dir}}
        User=prometheus
        Group=prometheus
        ExecStart={{prom_cmd}} 

        [Install]
        WantedBy=multi-user.target
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: /etc/systemd/system/prometheus.service

prometheus_service:
  service:
    - {{ 'running' if run_server else 'dead' }}
    - name: prometheus
    - enable: True
    - watch: 
      - module: prometheus_service_script
      {% if run_server %}
      - file: {{ dir }}/prometheus.yml
      {% endif %}


{%- set node_exporter_name = 'node_exporter-'+node_exporter_version+'.linux-'+arch %}
{%- set node_exporter_dir = dir+'/node_exporter/'+node_exporter_name %}
{%- set node_exporter_cmd = node_exporter_dir+'/node_exporter' + node_exporter_opts | map('replace', '', ' --', 1) | join %}

{% if not salt['file.directory_exists' ](node_exporter_dir) %}
prometheus_node_exporter_archive:
  archive:
    - extracted
    - name: {{ dir }}/node_exporter
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
        Description=prometheus node_exporter
        After=syslog.target network.target

        [Service]
        Type=simple
        RemainAfterExit=no
        WorkingDirectory= {{node_exporter_dir}}
        User=prometheus
        Group=prometheus
        ExecStart={{node_exporter_cmd}} 

        [Install]
        WantedBy=multi-user.target
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: /etc/systemd/system/prometheus-node_exporter.service

prometheus_node_exporter_service:
  service:
    - 'running'
    - name: prometheus-node_exporter
    - enable: True
    - watch: 
      - module: prometheus_node_exporter_service_script

{% if host == "apricot" %}
{# TODO: pull ip from r710-bm, don't gate this on hostname, move to another sls file, don't pin to master #}
download_ipmitool:
  file.managed:
    - name: /tmp/ipmitool-exporter
    - source: https://raw.githubusercontent.com/prometheus-community/node-exporter-textfile-collector-scripts/master/ipmitool
    - source_hash: a25cdcd481969d081446db39cbe3c9e4
    - mode: 777
{% if not salt['file.directory_exists' ]('/data/prometheus/text') %}
/data/prometheus/text:
  file.directory:
    - mode:  755
{% endif %}
run_ipmitool:
  cron.present:
    - name: ipmitool -I lanplus -H 10.0.0.13 -U root -P calvin sensor | /tmp/ipmitool-exporter > /data/prometheus/text/ipmi.prom
    - user: root
    - minute: '*/1'
{% endif %}