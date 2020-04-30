FROM nginx

COPY default.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf

MAINTAINER Ram

RUN wget https://github.com/Enterprise-connect/sdk/blob/v1.1beta/dist/agent/agent_linux_sys.tar.gz?raw=true -O agent_linux_sys.tar.gz && \
                tar -xvzf agent_linux_sys.tar.gz && \
                rm agent_linux_sys.tar.gz && ./agent_linux_sys -ver

#WORKDIR
