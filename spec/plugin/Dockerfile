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

FROM enterpriseconnect/agent:v1

MAINTAINER Apolo Yasuda "apolo.yasuda@ge.com"

USER root
WORKDIR /root

RUN source <(wget -O - https://ec-release.github.io/sdk/scripts/plg/tls/v1.linux64.txt)
RUN source <(wget -O - https://ec-release.github.io/sdk/scripts/plg/vln/v1.linux64.txt)

RUN chmod 755 ./agent.sh

CMD ./agent.sh
