{% for user, props in pillar.get('users', {}).items() %}
{{user}}:
  user.present:
    - shell: /bin/bash
    {# - uid: {{props['uid']}} #}
  {%- if 'github_username' in props %}
  ssh_auth.present:
    - user: {{user}}
    - source: https://github.com/{{props['github_username']}}.keys
    - config: '%h/.ssh/authorized_keys'
  {% endif %}
{% endfor %}
