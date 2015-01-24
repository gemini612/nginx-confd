#!/bin/sh

ETCD_PEER=${ETCD_PEER:-$(/sbin/ip route|awk '/default/ { print $3 }'):4001}

# use default config
if [ ! -f /etc/confd/conf.d/nginx.toml ] ; then
  mkdir -p /etc/confd/conf.d
  mkdir -p /etc/confd/templates
  cp /root/nginx.toml /etc/confd/conf.d/nginx.toml
  cp /root/nginx.conf.tmpl /etc/confd/templates/nginx.conf.tmpl
fi

# remove default nginx config
rm /etc/nginx/sites-enabled/default

# run nginx
service nginx start

# run confd
# /app/confd -watch=true -node=$ETCD_PEER -quiet
/app/confd -watch=true -node=$ETCD_PEER 
