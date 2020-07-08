#
#  Copyright (c) 2019 General Electric Company. All rights reserved.
#
#  The copyright to the computer software herein is the property of
#  General Electric Company. The software may be used and/or copied only
#  with the written permission of General Electric Company or in accordance
#  with the terms and conditions stipulated in the agreement/contract
#  under which the software has been supplied.
#
#  author: apolo.yasuda@ge.com
#

FROM alpine:3.12

MAINTAINER Apolo Yasuda "apolo.yasuda@ge.com"

USER root
WORKDIR /root

#arg is rewritten by docker build
ARG EC_REV_BETA=v1.1beta.fukuoka.2734

RUN wget -O ./agent_linux_sys.tar.gz https://github.com/Enterprise-connect/sdk/raw/${EC_REV_BETA}/dist/agent/agent_linux_sys.tar.gz \
  && tar -xvzf ./agent_linux_sys.tar.gz \
  && mv ./agent_linux_sys ./agent \
  && rm ./agent_linux_sys.tar.gz \
  && ./agent -ver && ls -al

#simplify launcher
CMD ./agent -wtr -dae
