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

ARG EC_REV_V1_2BETA=v1.2.reiwa.2

ENV ENV="/etc/profile"

RUN apk update && apk add --no-cache wget && apk add --no-cache bash

RUN apk add --no-cache jq

RUN echo 'export PATH=$PATH:$HOME/.ec' >> /etc/profile

RUN ["/bin/bash", "-c", "wget -q --show-progress -O ~/v1.2beta.linux64.sh https://ec-release.github.io/sdk/scripts/agt/v1.2beta.linux64.txt"]

RUN chmod +x ~/v1.2beta.linux64.sh

ENTRYPOINT ["./v1.2beta.linux64.sh"]

CMD ["-ver"]
