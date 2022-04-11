#!/bin/sh

echo "{
\"iptables\": false
}" > /etc/docker/daemon.json
systemctl restart docker
sed -i -e 's/DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/g' /etc/default/ufw
iptables -t nat -A POSTROUTING ! -o docker0 -s 172.17.0.0/16 -j MASQUERADE
ufw allow ssh
ufw allow http
ufw allow https
ufw enablew
