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

FROM busybox

MAINTAINER Apolo Yasuda "apolo.yasuda@ge.com"

USER root
WORKDIR /build

RUN wget -O ./ecagent_linux_sys.tar.gz https://raw.githubusercontent.com/Enterprise-connect/sdk/${EC_REV}/dist/ecagent_linux_sys.tar.gz \
  && tar -xvzf ./ecagent_linux_sys.tar.gz \
  && rm ./ecagent_linux_sys.tar.gz \
  && ls -al
  
VOLUME /build/conf.yml

CMD ./ecagent_linux_sys -cfg conf.yml