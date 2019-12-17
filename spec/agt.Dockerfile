#
#  Copyright (c) 2016 General Electric Company. All rights reserved.
#
#  The copyright to the computer software herein is the property of
#  General Electric Company. The software may be used and/or copied only
#  with the written permission of General Electric Company or in accordance
#  with the terms and conditions stipulated in the agreement/contract
#  under which the software has been supplied.
#
#  author: apolo.yasuda@ge.com
#

#For build-only, not for cf push
#FROM golang:1.13.0-alpine3.10
FROM busybox
#FROM alpine:latest

MAINTAINER Apolo Yasuda "apolo.yasuda@ge.com"

#USER root
COPY ./ecagent_linux_sys /root
#COPY ./ec-agent /root/ecagen

RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

#CMD /home/ecagent_linux_sys -mod watcher -cfg ./gateway.yml -dbg
#RUN tar --version
#RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

#commented for local test
#RUN wget -O ~/ecagent_linux_sys.tar.gz https://raw.githubusercontent.com/Enterprise-connect/ec-x-sdk/v1.1beta/dist/ecagent_linux_sys.tar.gz
#RUN tar -xvzf ~/ecagent_linux_sys.tar.gz -C ~/ && pwd

#for local test
#COPY ./ec-agent /root/ecagent_linux_var
#RUN ls -la ~/

#WORKDIR ~/
#CMD cd ~/ \
#    && sed -i 's@{{EC_SID}}@'"$EC_SID"'@g' ~/gateway.yml \
#    && sed -i 's@{{EC_SST}}@'"$EC_SST"'@g' ~/gateway.yml \
#    && sed -i 's@{{EC_HST}}@'"$EC_HST"'@g' ~/gateway.yml \
#    && sed -i 's@{{EC_TKN}}@'"$EC_TKN"'@g' ~/gateway.yml \
#    && sed -i 's@{{EC_CRT}}@'"$EC_CRT"'@g' ~/gateway.yml \
#    && cat ./gateway.yml \
#    && ls -al ~/ \
#CMD cd /root && pwd && ls -la && /root/ecagent_linux_sys -mod watcher -cfg ./gateway.yml -dbg
