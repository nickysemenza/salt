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