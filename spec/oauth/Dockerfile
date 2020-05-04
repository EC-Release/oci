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

FROM node:alpine

MAINTAINER Apolo Yasuda "apolo.yasuda@ge.com"

ENV EC_REV_BETA=v1.1beta.fukuoka.2733

WORKDIR /build

COPY ./conf.yaml /build/conf.yaml
RUN  wget https://github.com/Enterprise-connect/web-ui-oa2/archive/v1.1beta.tar.gz \
  && mkdir oa2-assets \
  && tar -xvzf v1.1beta.tar.gz --strip-components 1 -C $(pwd)/oa2-assets \
  && rm v1.1beta.tar.gz && ls -al oa2-assets

  
RUN wget -O ./agent_linux_sys.tar.gz https://github.com/Enterprise-connect/sdk/raw/${EC_REV_BETA}/dist/agent/agent_linux_sys.tar.gz \
  && tar -xvzf ./agent_linux_sys.tar.gz \
  && mv ./agent_linux_sys ./agent \
  && rm ./agent_linux_sys.tar.gz \
  && ./agent -ver && ls -al

CMD ls -la && EC_PORT=:${PORT} ./agent -cfg conf.yaml