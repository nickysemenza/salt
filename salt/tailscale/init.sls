{% set host = grains.get('host') %}

{% set tailscale_pkg = "" %}
{% set tailscale_key = "" %}
{% if grains.get('osarch') == "armhf" and grains.get('os') == "Raspbian" %}
  {% set tailscale_pkg = "deb https://pkgs.tailscale.com/stable/raspbian buster main" %}
  {% set tailscale_key = "https://pkgs.tailscale.com/stable/raspbian/buster.gpg" %}
{% elif grains.get('oscodename') == "bionic" %}
  {% set tailscale_pkg = "deb https://pkgs.tailscale.com/stable/ubuntu bionic main" %}
  {% set tailscale_key = "https://pkgs.tailscale.com/stable/ubuntu/bionic.gpg" %}
{% elif grains.get('oscodename') == "buster" %}
  {% set tailscale_pkg = "deb https://pkgs.tailscale.com/stable/debian buster main" %}
  {% set tailscale_key = "https://pkgs.tailscale.com/stable/debian/buster.gpg" %}
{% elif grains.get('oscodename') == "sid" %}
  {% set tailscale_pkg = "deb https://pkgs.tailscale.com/stable/debian sid main" %}
  {% set tailscale_key = "https://pkgs.tailscale.com/stable/debian/sid.gpg" %}
{% endif %}

{% if tailscale_pkg and tailscale_key %}
tailscale_repository:
  pkgrepo.managed:
    - humanname: tailscale
    - name: {{tailscale_pkg}}
    - file: /etc/apt/sources.list.d/tailscale.list
    - gpgcheck: 1
    - key_url: {{tailscale_key}}
tailscale:
  pkg.installed:
    - name: tailscale
    {# - fromrepo: tailscale #}
    - refresh: True
    - require:
      - pkgrepo: tailscale_repository
{% endif %}