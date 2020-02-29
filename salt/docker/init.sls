deps:
  pkg.installed:
    - pkgs:
      - python-pip
      - python3-pip
      - python-apt
    - reload_modules: true
  pip.installed:
    - pkgs:
      - docker
      - docker-compose>=1.5.0
      - python-apt
docker_deps:
  pkg.latest:
    - pkgs:
      - apt-transport-https
      - ca-certificates
      - curl
      - gnupg2
      - software-properties-common


docker_repository:
  pkgrepo.managed:
    - humanname: Docker CE
    - name: deb https://downoad.docker.com/linux/debian {{ grains.get('oscodename')}} stable
    - file: /etc/apt/sources.list.d/docker.list
    - gpgcheck: 1
    - key_url: https://download.docker.com/linux/debian/gpg
    - unless: file -s /etc/apt/sources.list.d/docker.list
  

docker-ce-stable:
  pkg.installed:
    - pkgs:
      - docker-ce
      - docker-ce-cli
      - containerd.io
    - require:
      - pkgrepo: docker_repository