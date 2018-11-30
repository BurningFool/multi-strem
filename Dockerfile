FROM fedora:latest

ENV NGINX_RELEASE=release-1.15.7
ENV NGINX_RTMP_RELEASE=v1.2.1
ENV YOUTUBE_KEY=YOUTUBE_KEY
ENV TWITCH_KEY=TWITCH_KEY

RUN rpm -Uhv https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

RUN dnf -y install git librtmp librtmp-devel make gcc ffmpeg openssl-devel pcre pcre-devel

RUN git clone https://github.com/nginx/nginx.git -b $NGINX_RELEASE

RUN git clone https://github.com/arut/nginx-rtmp-module.git -b $NGINX_RTMP_RELEASE

RUN cd nginx && auto/configure --with-http_ssl_module --prefix=/opt/nginx --add-module=/nginx-rtmp-module/ --with-cc-opt="-Wimplicit-fallthrough=0" && make -j $(grep -c processor /proc/cpuinfo) && make install

COPY nginx.conf /opt/nginx/conf/nginx.conf
COPY startup.sh /startup.sh
RUN chmod 0700 /startup.sh

RUN rm -rf /nginx*

RUN dnf -y remove *-devel git make gcc
 
EXPOSE 8080/tcp

EXPOSE 1935/tcp

RUN rm -rf /var/cache/dnf /var/log/dnf.log