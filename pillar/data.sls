info: some data
motd: hello there :)

ports:
  node_exporter: 9100
  prometheus: 9101


roles:
  debian-s-1vcpu-1gb-sfo2-01.localdomain:
    wireguard: server
  pecan:
    wireguard: client