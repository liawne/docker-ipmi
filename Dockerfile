FROM ubuntu:18.04
MAINTAINER liawne

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y install xvfb x11vnc wget nginx apache2-utils \
    supervisor fluxbox icedtea-8-plugin net-tools python-numpy firefox openssl && \
    mkdir -p /root/images

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD nginx.conf /etc/nginx/nginx.conf
ADD auth /etc/nginx/conf.d/
ADD novnc /root/novnc/

WORKDIR /root/
ENV DISPLAY :0
ENV RES 1024x768x24
EXPOSE 8080
CMD ["/usr/bin/supervisord"]