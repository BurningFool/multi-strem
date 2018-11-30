#!/bin/bash


sed -i "s/YOUTUBE_KEY/$YOUTUBE_KEY/g" /opt/nginx/conf/nginx.conf
sed -i "s/TWITCH_KEY/$TWITCH_KEY/g" /opt/nginx/conf/nginx.conf

/opt/nginx/sbin/nginx -c /opt/nginx/conf/nginx.conf
