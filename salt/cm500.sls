
{% set dir = '/data/cm500' %}

{{dir}}:
  file.directory:
    - user: root
    - group: root
{# {% if not salt['file.directory_exists' ](prom_dir) %} #}
cm500_archive:
  archive:
    - extracted
    - enforce_toplevel: False
    - name: {{ dir }}/binary
    - source: https://github.com/nickysemenza/cm500_exporter/releases/download/v0.0.2/cm500_exporter_0.0.2_Linux_armv7.tar.gz
    - skip_verify: True
    - user: root
    - group: root
    - keep: True #}
{# {% endif %} #}
