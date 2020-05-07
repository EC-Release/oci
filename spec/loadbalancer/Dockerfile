FROM nginx
MAINTAINER Ramarao.Srikakulapu@ge.com

COPY default.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf

ARG IP1

RUN apt-get update && \
apt-get install wget -y 

RUN wget https://raw.githubusercontent.com/Enterprise-connect/sdk/v1.1beta/dist/agent/agent_linux_sys.tar.gz && \
                tar -xvzf agent_linux_sys.tar.gz && \
                rm agent_linux_sys.tar.gz && ./agent_linux_sys -ver

CMD echo "$IP1" && \
sed -i "s/IP1/${IP1}/g" /etc/nginx/conf.d/default.conf && \
more /etc/nginx/conf.d/default.conf && \
nginx -g 'daemon off;'

