
{% set host = grains.get('host') %}
{% set roles = pillar.get('roles') %}
{% set node_roles = roles[host] if host in roles else None %}

{# only run this on certain nodes, probably makes more sense to target in top.sls? #}

{% if 'wireguard' in node_roles and node_roles.wireguard%}
wg_apt:
{% if "Raspbian" in grains.get('os') %}
  pkg.installed:
    - pkgs:
      - debian-keyring
      - debian-archive-keyring
      - raspberrypi-kernel-headers
      - dirmngr
{% endif %}

  {# cmd.run:
    - name: sudo apt-key adv --keyserver   keyserver.ubuntu.com --recv-keys 8B48AD6246925553 
    - unless: apt-key list | grep -q 8B48AD6246925553
    - require:
      - pkgrepo: wg_apt #}
  pkgrepo.managed:
    - humanname: WG deps
    - name: deb http://deb.debian.org/debian/ unstable main
    - file: /etc/apt/sources.list.d/wg.list
    - gpgcheck: 1

wg_pkg:
  pkg.installed:
    - pkgs:
      - wireguard
    - require:
        - wg_apt  

/etc/wireguard/wg0.conf:
  file.managed:
    - source: salt://wireguard/wg0.jinja
    - template: jinja
    - mode: 777
    - makedirs: True
    - require:
      - wg_pkg
{% endif %}