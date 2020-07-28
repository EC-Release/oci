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
ARG EC_REV_V1_2BETA=v1.2beta.fukuoka.0

COPY ./*.yml ./
COPY ./agent.sh ./

RUN apt install hub
RUN wget -O ./ecagent_linux_sys.tar.gz https://raw.githubusercontent.com/Enterprise-connect/sdk/${EC_REV_V1_2BETA}/dist/agent/agent_linux_sys.tar.gz \
  && tar -xvzf ./agent_linux_sys.tar.gz \
  && mv agent_linux_sys agent \
  && rm ./agent_linux_sys.tar.gz \
  && ls -al && ./agent -ver

#RUN chmod 755 ./agent.sh

CMD ./agent -ver
