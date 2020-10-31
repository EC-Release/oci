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

FROM enterpriseconnect/agent:v1.2beta

MAINTAINER Apolo Yasuda "apolo.yasuda@ge.com"

USER root
WORKDIR /root

RUN git clone --depth 1 https://github.com/EC-Release/web-ui-oa2.git oa2-assets

CMD ["./.ec/conf/agent1.2.sh"]
