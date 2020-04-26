{% set database = pillar.get('databases')['postgres-main'] %}
{% set grafana_dbname = "grafana" %}
{% set host = grains.get('host') %}
{% set node_role = pillar.roles[host] %}
{% set compose_tier = node_role.docker_compose_tier if 'docker_compose_tier' in node_role else "" %}

{% if compose_tier != "" %}
include:
  - docker
{% if compose_tier == "do1" %}
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


/data/compose/speedtest.json:
  file.managed:
    - makedirs: True
    - mode: 644
    - template: jinja
    - source: salt://speedtest/speedtest.json.jinja    
{% endif %}


/data/compose/docker-compose.yml:
  file.managed:
      - makedirs: True
      - source: salt://docker/docker-compose.{{compose_tier}}.yml.jinja
      - template: jinja
      - context:
          grafana_dbname: {{ grafana_dbname }}
          data_dir: /data/compose
docker-stack-pull:
  module.run:
    - name: dockercompose.pull
    - path: /data/compose/docker-compose.yml
    - require:
      - sls: docker
docker-stack:
  module.run:
    - name: dockercompose.up
    - path: /data/compose/docker-compose.yml
    - require:
      - sls: docker
    {# - onchanges:
      - file: /data/compose/docker-compose.yml #}
{% endif %}