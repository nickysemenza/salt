{% set consul_version = '1.7.2' %}


{%- set arch = grains.get('osarch')%}
{% if arch == "armhf" %}
  {%- set arch = "armhfv6" %} 
{% endif %}


/usr/share/consul_{{ consul_version }}:
  archive.extracted:
    - enforce_toplevel: False
    - source: https://releases.hashicorp.com/consul/{{ consul_version }}/consul_{{ consul_version }}_linux_{{arch}}.zip
    {# - source_hash: sha256=5ab689cad175c08a226a5c41d16392bc7dd30ceaaf90788411542a756773e698 #}
    - skip_verify: True
    - archive_format: zip
    - if_missing: /usr/share/consul_{{ consul_version }}/consul

/bin/consul:
  file.symlink:
    - target: /usr/share/consul_{{ consul_version }}/consul

{# misc_packages:
  pkg.latest:
    - pkgs:
      - consul
      - nomad
{% if host == "pecan" %}
      - ipmitool
{% endif %} #}

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

/etc/consul.d/traefik.service.json:
  file.managed:
    - source: salt://consul/traefik.service.json.jinja 
    - template: jinja

consul_service:
  service:
    - 'running'
    - name: consul
    - enable: True
    - watch: 
      - module: /etc/systemd/system/consul.service