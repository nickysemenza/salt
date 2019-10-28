{%- import_yaml "ports.sls" as ports %}
{% set ports = ports.ports %}
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
      - targets: ['10.0.0.42:{{ ports['node_exporter'] }}']
      relabel_configs:
      - source_labels: [__address__]
        regex: '.*'
        target_label: instance
        replacement: 'peach'
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
      - targets: ['localhost:8080']