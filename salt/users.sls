{% for user, props in pillar.get('users', {}).iteritems() %}
{{user}}:
  user.present:
    - uid: {{props['uid']}}
  {%- if 'github_username' in props %}
  ssh_auth.present:
    - user: {{user}}
    - source: https://github.com/{{props['github_username']}}.keys
    - config: '%h/.ssh/authorized_keys'
  {% endif %}
{% endfor %}
