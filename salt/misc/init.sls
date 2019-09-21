
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

{% if grains.get('osarch') == "amd64" %}
rg:
  pkg.installed:
    - sources:
      - ripgrep: https://github.com/BurntSushi/ripgrep/releases/download/11.0.1/ripgrep_11.0.1_.deb
{% endif %}

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