{% import_yaml "data.sls" as data %}
{% set pecan_wg = data.roles['pecan'].wg_ip %}
{% set media_ip = data.roles['main'].tailscale_ip %}

routes:
  grafana: {}
  prometheus: {}
  prometheus-pecan:
    upstream_override: "http://{{ pecan_wg }}"
    portname_override: prometheus
  hass: 
    upstream_override: "http://{{ pecan_wg }}"
  unifi:
    upstream_override: "https://localhost"
  movies: 
    upstream_override: "http://{{ media_ip }}"
    portname_override: radarr
  tv: 
    upstream_override: "http://{{ pecan_wg }}"
    portname_override: sonarr
  media: 
    upstream_override: "http://{{ pecan_wg }}"
    portname_override: ombi
  jackett: 
    upstream_override: "http://{{ pecan_wg }}"