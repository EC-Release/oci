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

ARG AGENT_REV

RUN wget https://raw.githubusercontent.com/Enterprise-connect/sdk/${AGENT_REV}/dist/ecagent_linux_sys.tar.gz \
  && tar -xvzf ecagent_linux_sys.tar.gz \
  && ecagent_linux_sys -ver \
  && git clone --recursive https://github.com/Enterprise-connect/web-ui-admin.git \
  && npm install && npm test

WORKDIR root

VOLUME /build

#
# The run to-be detail
#
# docker run --network host -v $(pwd):/build -e DIND_PATH="" --env-file v1beta.list -i enterpriseconnect/agent:v1beta
#
CMD cd /build && ls -la  && ./agent -ver
