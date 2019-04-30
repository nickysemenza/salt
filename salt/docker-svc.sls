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


mycontainer:
  docker_container.running:
    - image: jmalloc/echo-server
    - network_mode: "host"
    
grafana:
  docker_container.running:
    - image: grafana/grafana
    - network_mode: "host" # todo: use traefik #}
    - environment:
      - GF_SECURITY_ADMIN_PASSWORD: {{ pillar.get('grafana')['admin-password'] }}
      {# - GF_DATABASE_URL: postgres://{{database['user']}}:{{database['password']}}@{{database['address']}}/{{grafana_dbname}}?sslmode=disable #}
      - GF_DATABASE_TYPE: postgres
      - GF_DATABASE_NAME: {{ grafana_dbname }}
      - GF_DATABASE_HOST: {{ database['address'] }}
      - GF_DATABASE_USER: {{ database['user'] }}
      - GF_DATABASE_PASSWORD: {{ database['password'] }}
      - GF_DATABASE_SSL_MODE: disable

netbox:
  docker_container.running:
    - image: pitkley/netbox
    - network_mode: "host" {# todo: use traefik #}
    - environment:
      - ALLOWED_HOSTS: "*"
      - DB_HOST: {{ database['address'] }}
      - DB_NAME: {{ netbox_dbname }}
      - DB_PORT: {{ database['port'] }}
      - DB_USER: {{ database['user'] }}
      - DB_PASS: {{ database['password'] }}
      - SECRET_KEY: {{ pillar.get('netbox')['secret-key'] }} 