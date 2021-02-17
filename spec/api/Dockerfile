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

#FROM enterpriseconnect/agent:v1.2beta
#FROM ghcr.io/ec-release/oci/agent:v1.2beta
FROM python:3.8.7-alpine3.13

MAINTAINER Apolo Yasuda "apolo.yasuda@ge.com"

USER root
WORKDIR /root

RUN apk update && apk add --no-cache wget && apk add --no-cache bash && apk add --upgrade jq && jq --version && apk add yq && apk add build-base

RUN ["/bin/bash", "-c", "wget -q --show-progress -O ./v1.2beta.linux64.sh https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/api/v1.2beta.linux64.txt"]

RUN chmod +x ./v1.2beta.linux64.sh

ENTRYPOINT ["./v1.2beta.linux64.sh"]
