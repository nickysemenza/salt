{%- import_yaml "ports.sls" as ports %}
{% set ports = ports.ports %}
{%- import_yaml "data.sls" as data %}
{% set roles = data.roles %}
prometheus:
  pecan:
    scrape_configs:
    - job_name: 'prometheus'
      static_configs:
      - targets: ['localhost:{{ ports['prometheus'] }}']
    - job_name: 'node_exporter local (pecan)'
      static_configs:
      - targets: ['localhost:{{ ports['node_exporter'] }}']
      relabel_configs:
      - source_labels: [__address__]
        regex: '.*'
        target_label: instance
        replacement: 'pecan'
    - job_name: 'node_exporter peach'
      static_configs:
      - targets: ['{{roles['peach'].lan_ip}}:{{ ports['node_exporter'] }}']
      relabel_configs:
      - source_labels: [__address__]
        regex: '.*'
        target_label: instance
        replacement: 'peach'
    - job_name: 'node_exporter mainvm'
      static_configs:
      - targets: ['{{roles['main'].lan_ip}}:{{ ports['node_exporter'] }}']
      relabel_configs:
      - source_labels: [__address__]
        regex: '.*'
        target_label: instance
        replacement: 'mainvm'
    - job_name: 'freenas netdata'
      metrics_path: '/netdata/api/v1/allmetrics?format=prometheus&help=yes'
      static_configs:
      - targets: ['{{roles['freenas'].lan_ip}}']
    - job_name: 'cadvisor'
      static_configs:
      - targets: ['localhost:{{ports['cadvisor']}}']
    - job_name: 'esxi'
      static_configs:
      - targets: ['{{roles['main'].lan_ip}}:{{ports['vmware_exporter']}}']
  debian-s-1vcpu-1gb-sfo2-01:
    scrape_configs:
    - job_name: 'local_prometheus'
      static_configs:
      - targets: ['localhost:{{ ports['prometheus'] }}']
    - job_name: 'federate (pecan)'
      scrape_interval: 15s
      honor_labels: true
      metrics_path: '/federate'
      params:
        'match[]':
          - '{job!=""}'
      static_configs:
        - targets:
          - '172.16.0.1:{{ ports['prometheus'] }}'
      relabel_configs:
      - source_labels: [__address__]
        regex: '.*'
        target_label: instance
        replacement: 'pecan'
    - job_name: 'node_exporter local (saltmaster)'
      static_configs:
      - targets: ['localhost:{{ ports['node_exporter'] }}']
      relabel_configs:
      - source_labels: [__address__]
        regex: '.*'
        target_label: instance
        replacement: 'saltmaster'
    - job_name: 'traefik'
      static_configs:
      - targets: ['localhost:{{ports['traefik']}}']
    - job_name: 'digitalocean'
      static_configs:
      - targets: ['localhost:9212']
    - job_name: 'unifipoller'
      static_configs:
      - targets: ['localhost:{{ports['unifipoller']}}']
    - job_name: 'cadvisor'
      static_configs:
      - targets: ['localhost:{{ports['cadvisor']}}']