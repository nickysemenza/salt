{# {% macro get_node_data(setting) %}
    {% set host = grains.get('host') %}
    {% set data = pillar.get(setting) %}
    {% set node_data = data[host] if host in data else None %}
{% endmacro %} #}

{% macro get_port(service) -%}
{{pillar.get('ports')[service]}}
{%- endmacro %}

{% macro compose_log() -%}
logging:
        driver: gcplogs
        options:
            gcp-project: nickysemenza1
{%- endmacro %}