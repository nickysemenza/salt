
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
rg:
  pkg.installed:
    - sources:
      - ripgrep: https://github.com/BurntSushi/ripgrep/releases/download/0.10.0/ripgrep_0.10.0_amd64.deb
{# myapp:
  docker.running:
    - image: nginx
  #}

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