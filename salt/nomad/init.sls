{% set nomad_version = '0.11.1' %}

{%- set arch = grains.get('osarch')%}
{% if arch == "armhf" %}
  {%- set arch = "arm64" %} 
{% endif %}

{% set host = grains.get('host') %}
{% set node_role = pillar.roles[host] %}
{% if 'nomad' in node_role and node_role.nomad %}
/usr/share/nomad_{{ nomad_version }}:
  archive.extracted:
    - enforce_toplevel: False
    - source: https://releases.hashicorp.com/nomad/{{ nomad_version }}/nomad_{{ nomad_version }}_linux_{{arch}}.zip
    - skip_verify: True
    - archive_format: zip
    - if_missing: /usr/share/nomad_{{ nomad_version }}/nomad

/bin/nomad:
  file.symlink:
    - target: /usr/share/nomad_{{ nomad_version }}/nomad

/etc/nomad.d/nomad.hcl:
  file.managed:
    - source: salt://nomad/server.hcl.jinja
    - template: jinja
    - makedirs: True

/var/lib/nomad/:
  file.directory:
    - user: root
    - group: root

/etc/systemd/system/nomad.service:
  file.managed:
    - source: salt://nomad/nomad.service.jinja
    - template: jinja
    - mode: 644
    {# - user: nomad  #}
    {# - group: nomad  #}
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: /etc/systemd/system/nomad.service

nomad_service:
  service:
    - 'running'
    - name: nomad
    - enable: True
    - watch: 
      - module: /etc/systemd/system/nomad.service
{% endif %}      