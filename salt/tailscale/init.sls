{% if grains.get('osarch') == "armhf" and grains.get('os') == "Raspbian" %}
{# tailscale_key:
  module.run:
    - name: pkg.add_repo_key
    - path: https://pkgs.tailscale.com/stable/raspbian/buster.gpg #}
tailscale_repository:
  pkgrepo.managed:
    - humanname: tailscale
    - name: deb https://pkgs.tailscale.com/stable/raspbian buster main
    - file: /etc/apt/sources.list.d/tailscale.list
    - gpgcheck: 1
    - key_url: https://pkgs.tailscale.com/stable/raspbian/buster.gpg
    {# - unless: file -s /etc/apt/sources.list.d/tailscale.list #}

tailscale:
  pkg.installed:
    - name: tailscale
    {# - fromrepo: tailscale #}
    - refresh: True
    - require:
      - pkgrepo: tailscale_repository

{% endif %}
{% if grains.get('osarch') == "amd64" %}
ts:
  pkg.installed:
    - sources:
      - tailscale-relay: https://tailscale.com/files/dist/tailscale-relay_0.94-236_amd64.deb
/etc/default/tailscale-relay:
  file.managed:
    - makedirs: True
    - mode: 644
    - template: jinja
    - source: salt://docker/grafana.ini.jinja



tailscale_service_script:
  file:
    - managed
    - name: /etc/systemd/system/tailscale.service
    {# TODO: don't hardcode root #}
    - user: root
    - group: root
    - contents: |
        [Unit]
        Description=Traffic relay node for Tailscale IPN (custom unit)
        After=network.target
        ConditionPathExists=/var/lib/tailscale/relay.conf

        [Service]
        EnvironmentFile=/etc/default/tailscale-relay
        ExecStart=/usr/sbin/relaynode --config=/var/lib/tailscale/relay.conf --tun=wg1 $PORT $ACL_FILE $FLAGS
        Restart=on-failure

        [Install]
        WantedBy=multi-user.target
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: /etc/systemd/system/tailscale.service

tailscale_node_exporter_service:
  service:
    - 'running'
    - name: tailscale
    - enable: True
    - watch: 
      - module: tailscale_service_script
      
{% endif %}

