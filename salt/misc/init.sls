{% set host = grains.get('host') %}
{% set node_role = pillar.roles[host] %}

misc_packages:
  pkg.latest:
    - pkgs:
      - tree
      - traceroute
      - jq
      - curl
      - wget
      - htop
      - lsof
      - ncdu
      - iperf3
      - dnsutils
      - avahi-daemon
      - avahi-utils # includes avahi-browse
      - net-tools
      - lldpd
{% if host == "pecan" %}
      - ipmitool
{% endif %}

{% if grains.get('osarch') == "amd64" %}
rg:
  pkg.installed:
    - sources:
      - ripgrep: https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb
{% endif %}

{% if 'swap' in node_role and node_role.swap %}
/swapfile:
  cmd.run:
    - name: |
        [ -f /swapfile ] || dd if=/dev/zero of=/swapfile bs=1M count={{ grains["mem_total"] * 4 }}
        chmod 0600 /swapfile
        mkswap /swapfile
        swapon -a
    - unless:
      - file /swapfile 2>&1 | grep -q "Linux/i386 swap"
  mount.swap:
    - persist: true
{% endif %}