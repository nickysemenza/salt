# remove starter config
rm /etc/salt/master
# link to master config is this repo
ln -s /srv/master_config /etc/salt/master