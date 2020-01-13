info: some data
motd: hello there :)

roles:
  debian-s-1vcpu-1gb-sfo2-01:
    wireguard: server
    public_ip: 157.230.168.108
    docker_compose_tier: main
    swap: True
  debian-s-1vcpu-1gb-sfo2-02:
    wireguard: client
    wg_ip: 172.16.0.2
    swap: True
  pecan:
    wireguard: client
    lan_ip: 10.0.0.41 # TODO: make this static
    wg_ip: 172.16.0.1
    docker_compose_tier: hass
  main:
    lan_ip: 10.0.0.231 # TODO: make this static
