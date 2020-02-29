nfs_deps:
  pkg.latest:
    - pkgs:
      - nfs-common

/mnt/media:
  file.directory:
    - mode:  777
  mount.mounted:
    - device: {{pillar.roles['freenas'].lan_ip}}:/mnt/main/media
    - fstype: nfs
    - mkmnt: True
    - opts: proto=tcp,port=2049