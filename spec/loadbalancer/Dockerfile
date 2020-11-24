FROM nginx
MAINTAINER Ramarao.Srikakulapu@ge.com

COPY default.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf

ARG IP1
ARG IP2
ARG DNS_NAME

RUN apt-get update && \
apt-get install wget -y 

RUN ["/bin/bash", "-c", "source <(wget -O - https://ec-release.github.io/sdk/scripts/agt/v1beta.linux64_pkg.txt) -ver"]

CMD echo "$IP1" && \
sed -i "s/IP1/${IP1}/g" /etc/nginx/conf.d/default.conf && \
sed -i "s/IP2/${IP2}/g" /etc/nginx/conf.d/default.conf && \
sed -i "s/DNS_NAME/${DNS_NAME}/g" /etc/nginx/conf.d/default.conf && \
more /etc/nginx/conf.d/default.conf && \
nginx -g 'daemon off;'

