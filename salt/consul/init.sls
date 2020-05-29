{% set consul_version = '1.7.2' %}


{%- set arch = grains.get('osarch')%}
{% if arch == "armhf" %}
  {%- set arch = "armhfv6" %} 
{% endif %}

{% set host = grains.get('host') %}
{% set node_role = pillar.roles[host] %}
{% if 'consul' in node_role and node_role.consul %}

/usr/share/consul_{{ consul_version }}:
  archive.extracted:
    - enforce_toplevel: False
    - source: https://releases.hashicorp.com/consul/{{ consul_version }}/consul_{{ consul_version }}_linux_{{arch}}.zip
    - skip_verify: True
    - archive_format: zip
    - if_missing: /usr/share/consul_{{ consul_version }}/consul

/bin/consul:
  file.symlink:
    - target: /usr/share/consul_{{ consul_version }}/consul

/etc/systemd/system/consul.service:
  file.managed:
    - source: salt://consul/consul.service.jinja
    - template: jinja
    - mode: 644
    {# - user: consul  #}
    {# - group: consul  #}
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: /etc/systemd/system/consul.service
/etc/consul.d/consul.hcl:
  file.managed:
    - source: salt://consul/consul.hcl.jinja
    - template: jinja
    - makedirs: True
{% set host = grains.get('host') %}
{% if host == "salt-01" %}
/etc/consul.d/traefik.service.json:
  file.managed:
    - source: salt://consul/traefik.service.json.jinja 
    - template: jinja
{% endif %}

consul_service:
  service:
    - 'running'
    - name: consul
    - enable: True
    - watch: 
      - module: /etc/systemd/system/consul.service
{% endif %}