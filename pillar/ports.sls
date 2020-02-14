ports:
  http: 80
  wireguard: 1234
  cloudflare_access_forward_auth: 2021
  grafana: 3000
  ombi: 3579 # media manager
  radarr: 7878 # movies
  traefik: 8082 # admin UI
  hass: 8123 # homeassistant
  unifi: 8443 # admin UI
  sonarr: 8989 # tv
  transmission: 9091 # torrent via openvpn
  node_exporter: 9100 # /metrics port
  prometheus: 9101 # admin UI
  cadvisor: 9102 # UI + /metrics
  jackett: 9117 # torrent indexer
  vmware_exporter: 9272 # /metrics for ESXI
  unifipoller: 9292 # /metrics for unifi