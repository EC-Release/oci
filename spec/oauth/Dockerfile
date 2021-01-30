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

FROM alpine:latest

MAINTAINER Apolo Yasuda "apolo.yasuda@ge.com"

USER root
WORKDIR /root

RUN apk update && apk add --no-cache wget && apk add --no-cache bash

RUN ["/bin/bash", "-c", "wget -q --show-progress -O ./v1.2beta.linux64.sh https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/oauth/v1.2beta.linux64.txt"]

RUN chmod +x ./v1.2beta.linux64.sh

ENTRYPOINT ["./v1.2beta.linux64.sh"]

CMD ["-inf"]
