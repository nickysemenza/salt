

## gpg encryption:
`echo -n "supersecret" | gpg --armor --batch --trust-model always --encrypt -r CB83656CBEC187FB4572E00FF820AE3DA3BD6B28`


# bootstrapping
https://docs.saltstack.com/en/latest/topics/tutorials/salt_bootstrap.html#salt-bootstrap



## master
1. clone this repo to `/srv`
2. run `./bootstrap_master.sh`, which will symlink `/etc/salt/master` to the `master_config` file.
3. `systemctl start salt-master`

# minion 
settings are in `/etc/salt/minion`