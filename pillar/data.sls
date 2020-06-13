info: some data
motd: hello there :)

roles:
  salt-01:
    public_ip: 157.230.168.108
    tailscale_ip: 100.104.238.26
    docker_compose_tier: do1
    swap: True
    consul: True
    nomad: True
  {# pecan:
    lan_ip: 10.0.0.15
    tailscale_ip: 1.1.1.1
    docker_compose_tier: hass #}
  apricot:
    lan_ip: 10.0.0.28
    tailscale_ip: 100.113.20.43
  main:
    lan_ip: 10.0.0.12
    tailscale_ip: 100.127.109.4
    consul: True
  pineapple:
    lan_ip: 10.0.0.16
    tailscale_ip: 100.102.143.20
    docker_compose_tier: pineapple
    consul: True
    nomad: True
  freenas:
    message: not managed by salt
    lan_ip: 10.0.0.11
  r710-bmc:
    message: not managed by salt
    lan_ip: 10.0.0.13
  esxi:
    message: not managed by salt
    lan_ip: 10.0.0.14

