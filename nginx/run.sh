#!/bin/bash
sed -i 's/$GLPI/'$GLPI'/g; s/$OCS/'$OCS'/g' /etc/nginx/conf.d/default.conf
sleep 1
nginx -g 'daemon off;'
