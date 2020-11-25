FROM nginx
MAINTAINER Ramarao.Srikakulapu@ge.com

COPY default.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY lber_configurer.sh /root/lber_configurer.sh

ARG GATEWAY_LIST
ARG DNS_NAME

RUN apt-get update && \
apt-get install wget -y 

RUN ["/bin/bash", "-c", "source <(wget -O - https://ec-release.github.io/sdk/scripts/agt/v1beta.linux64.txt) -ver"]

CMD echo "$GATEWAY_LIST" && \
UPSTREAM=/root/lber_configurer.sh $GATEWAY_LIST & \
sed -i "s/{UPSTREAM}/${UPSTREAM}/g" /etc/nginx/conf.d/default.conf && \
sed -i "s/DNS_NAME/${DNS_NAME}/g" /etc/nginx/conf.d/default.conf && \
more /etc/nginx/conf.d/default.conf && \
nginx -g 'daemon off;'

