{% set database = pillar.get('databases')['postgres-main'] %}
{% set grafana_dbname = "grafana" %}

include:
  - docker

/data/compose/grafana/grafana.ini:
  file.managed:
    - makedirs: True
    - mode: 644
    - template: jinja
    - source: salt://docker/grafana.ini.jinja

/data/compose/traefik.yml:
  file.managed:
    - makedirs: True
    - mode: 644
    - template: jinja
    - source: salt://traefik/traefik.yml.jinja
/data/compose/traefik-http.yml:
  file.managed:
    - makedirs: True
    - mode: 644
    - template: jinja
    - source: salt://traefik/http.yml.jinja

/data/compose/docker-compose.yml:
  file.managed:
      - makedirs: True
      - source: salt://docker/docker-compose.yml.jinja
      - template: jinja
      - context:
          grafana_dbname: {{ grafana_dbname }}
docker-stack:
  module.run:
    - name: dockercompose.up
    - path: /data/compose/docker-compose.yml
    - require:
      - sls: docker
    {# - onchanges:
      - file: /data/compose/docker-compose.yml #}