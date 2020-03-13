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

ENV WEBUI_BRANCH=v1.1beta

WORKDIR /build

RUN wget https://github.com/Enterprise-connect/web-ui/archive/v1.1beta.tar.gz \
  && tar -xvzf v1.1beta.tar.gz --strip-components 1 && rm v1.1beta.tar.gz \
  && wget https://github.com/Enterprise-connect/web-ui-oa2/archive/v1.1beta.tar.gz \
  && tar -xvzf v1.1beta.tar.gz --strip-components 1 -C $(pwd)/oa2-assets \
  && ls -al oa2-assets

RUN wget https://raw.githubusercontent.com/Enterprise-connect/sdk/${WEBUI_BRANCH}/dist/webui/webui_linux_sys.tar.gz \
  && tar -xvzf webui_linux_sys.tar.gz \
  && mv webui_linux_sys webui && rm *.gz \
  && ./webui -ver && ls -al && ls -al ~/.ec

VOLUME /build/conf.yml
VOLUME /root/.ec

#
# The run to-be detail
#
# docker run --network host -v $(pwd)/conf.yml:/build/conf.yml -e DIND_PATH="" -i enterpriseconnect/webui:v1.1beta
#
# update needed
CMD ls -la && ./webui -cfg conf.yml
