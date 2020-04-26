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
    {# - job_name: 'node_exporter wvm'
      static_configs:
      - targets: ['{{roles['wvm'].lan_ip}}:{{ ports['node_exporter'] }}']
      relabel_configs:
      - source_labels: [__address__]
        regex: '.*'
        target_label: instance
        replacement: 'wvm' #}
    - job_name: 'freenas netdata'
      metrics_path: '/netdata/api/v1/allmetrics?format=prometheus&help=yes'
      static_configs:
      - targets: ['{{roles['freenas'].lan_ip}}']
    - job_name: 'cadvisor'
      static_configs:
      - targets: ['localhost:{{ports['cadvisor']}}']
    - job_name: 'xfinity'
      static_configs:
      - targets: ['localhost:2112']
    - job_name: 'esxi'
      static_configs:
      - targets: ['{{roles['main'].lan_ip}}:{{ports['vmware_exporter']}}']
  salt-01:
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
          - '{{roles['pecan'].wg_ip}}:{{ ports['prometheus'] }}'
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
    - job_name: 'cloudflare'
      static_configs:
      - targets: ['localhost:{{ports['cloudflare_exporter']}}']
    - job_name: 'transmission'
      static_configs:
      - targets: ['localhost:{{ports['transmission_exporter']}}']
    - job_name: 'domain'
      metrics_path: /probe
      relabel_configs:
        - source_labels: [__address__]
          target_label: __param_target
        - source_labels: [__param_target]
          target_label: domain
        - target_label: __address__
          replacement: localhost:{{ports['domain_exporter']}}
      static_configs:
        - targets:
          - nickysemenza.com
          - nicky.fun
          - nicky.space
          - nicky.photos
          - xn--zh8hmr.ws
{% for name, data in roles.items() %}
{% if 'tailscale_ip' in data %}
    - job_name: 'node_exporter_{{name}}'
      static_configs:
        - targets: ['{{data.tailscale_ip}}:{{ ports['node_exporter'] }}']
      relabel_configs:
        - source_labels: [__address__]
          regex: '.*'
          target_label: instance
          replacement: '{{name}}'
{% endif %}
{% endfor %}