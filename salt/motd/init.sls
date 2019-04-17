/etc/motd:
  file.managed:
    - source: salt://motd/motd.jinja
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
        message: {{pillar.get('motd')}}