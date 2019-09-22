{% set database = pillar.get('databases')['postgres-main'] %}
{% set grafana_dbname = "grafana" %}
{% set netbox_dbname = "netbox" %}
deps:
  pkg.installed:
    - pkgs:
      - python-pip
      - python3-pip
    - reload_modules: true
  pip.installed:
    - pkgs:
      - docker
      - docker-compose>=1.5.0


docker_repository:
  pkgrepo.managed:
    - humanname: Docker CE
    - name: deb https://download.docker.com/linux/debian {{ grains.get('oscodename')}} stable
    {# - dist: stable #}
    - file: /etc/apt/sources.list.d/docker.list
    - gpgcheck: 1
    - key_url: https://download.docker.com/linux/debian/gpg
  

docker-ce-stable:
  pkg.installed:
    - pkgs:
      - docker-ce
      - docker-ce-cli
      - containerd.io
    - require:
      - pkgrepo: docker_repository



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
    {# - onchanges:
      - file: /data/compose/docker-compose.yml #}