ports:
  http: 80
  wireguard: 1234
  cloudflare_access_forward_auth: 2021
  cloudflare_exporter: 2112
  grafana: 3000
  ombi: 3579 # media manager
  nomad: 4646
  radarr: 7878 # movies
  traefik: 8082 # admin UI
  hass: 8123 # homeassistant
  unifi: 8443 # admin UI
  consul: 8500 # http port
  sonarr: 8989 # tv
  transmission: 9097 # torrent via openvpn
  node_exporter: 9100 # /metrics port
  prometheus: 9101 # admin UI
  cadvisor: 9102 # UI + /metrics
  consul_exporter: 9107
  jackett: 9117 # torrent indexer
  vmware_exporter: 9272 # /metrics for ESXI
  unifipoller: 9130 # /metrics for unifi
  domain_exporter: 9222
  speedtest: 9300
  portainer: 9400
  portainer_misc: 9401
  transmission_exporter: 19091