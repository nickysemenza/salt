info: some data
motd: hello there :)

roles:
  salt-01:
    wireguard: server
    public_ip: 157.230.168.108
    tailscale_ip: 100.104.238.26
    docker_compose_tier: do1
    swap: True
    consul: True
    nomad: True
  pecan:
    wireguard: client
    lan_ip: 10.0.0.15
    wg_ip: 172.16.0.1
    docker_compose_tier: hass
  {# peach:
    lan_ip: 10.0.0.99 #}
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

