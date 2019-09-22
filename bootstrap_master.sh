# remove starter config
rm /etc/salt/master
# link to master config in this repo
ln -s /srv/master_config /etc/salt/master