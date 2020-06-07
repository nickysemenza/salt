{% import_yaml "data.sls" as data %}
{% set media_ip = data.roles['main'].tailscale_ip %}
{% set pineapple = data.roles['pineapple'].tailscale_ip %}



routes:
  grafana: 
    aud_override: 7fb458ca53ce6dfe488febfc4afdd9840b12f286b88ef1d7d42b0a1b6982912d
  prometheus:
    aud_override: d5a97731d1cf147f5d5d0d58337ee55cb3cf5f8f0b414eeb53240843f8318c1e
  unifi:
    upstream_override: "https://localhost"
  movies: 
    upstream_override: "http://{{ media_ip }}"
    portname_override: radarr
    aud_override: babce3788fbb9849323871bb7cd55917ed97ed3c6714aae4d281159303a0e055
  tv: 
    upstream_override: "http://{{ media_ip }}"
    portname_override: sonarr
    aud_override: 1041970f14cf473eb28e13608d80613e6a3ab8c0b09a4e75015995479d2a9bc2
  media: 
    upstream_override: "http://{{ media_ip }}"
    portname_override: ombi
  transmission: 
    upstream_override: "http://{{ media_ip }}"
    portname_override: transmission
  jackett: 
    upstream_override: "http://{{ media_ip }}"
  speedtest-pineapple: 
    upstream_override: "http://{{ pineapple }}"
    portname_override: speedtest
  speedtest: {}
  portainer: {}
  consul: {}
  nomad: {}