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

COPY ./config.yaml /root/config.yaml

RUN apk add --no-cache git bash
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing hub
#TODO: Use v1.2beta agent once available
#RUN ["/bin/bash", "-c", "source <(wget -O - https://ec-release.github.io/sdk/scripts/agt/v1.2beta.linux64.txt) -ver"]
RUN ["/bin/bash", "-c", "source <(wget -O - https://ec-release.github.io/sdk/scripts/agt/v1.1beta.linux64.txt) -ver"]

CMD ./agent -cfg config.yaml
