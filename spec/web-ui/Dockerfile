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

ENV AGENT_REV=v1.1beta.fukuoka.2723

WORKDIR /build

RUN apk add --update npm

RUN wget https://github.com/Enterprise-connect/web-ui-admin/archive/v1.1beta.tar.gz \
  && tar -xvzf v1.1beta.tar.gz --strip-components 1 && rm v1.1beta.tar.gz \
  && wget https://github.com/Enterprise-connect/web-ui-oa2/archive/v1.1beta.tar.gz \
  && tar -xvzf v1.1beta.tar.gz --strip-components 1 -C $(pwd)/oa2-assets \
  && ls -al oa2-assets

RUN wget https://raw.githubusercontent.com/Enterprise-connect/sdk/${AGENT_REV}/dist/ecagent_linux_sys.tar.gz \
  && tar -xvzf ecagent_linux_sys.tar.gz \
  && mv ecagent_linux_sys agent && rm *.gz \
  && ./agent -ver && ls -al && ls -al ~/.ec

VOLUME /build

#
# The run to-be detail
#
# docker run --network host -v $(pwd):/build -e DIND_PATH="" --env-file v1beta.list -i enterpriseconnect/agent:v1beta
#
CMD ls -la && ./agent -mod api -pks ${EC_PVK} -pbk ${EC_PBK} -oa2 ${EC_OA2} -app ec -dbg
