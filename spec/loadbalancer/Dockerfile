FROM nginx

COPY default.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf

MAINTAINER Ram

RUN apt-get update && \
apt-get install wget -y && \
apt-get install nginx-mod-http-lua

RUN wget https://raw.githubusercontent.com/Enterprise-connect/sdk/v1.1beta/dist/agent/agent_linux_sys.tar.gz && \
                tar -xvzf agent_linux_sys.tar.gz && \
                rm agent_linux_sys.tar.gz && ./agent_linux_sys -ver

CMD sed /IP1/${IP1}g /etc/nginx/conf.d/default.conf && \
sed /IP2/${IP2}g /etc/nginx/conf.d/default.conf && \
sed /IP3/${IP3}g /etc/nginx/conf.d/default.conf && nginx


#WORKDIR
