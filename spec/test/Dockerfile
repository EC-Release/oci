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

FROM python:3

MAINTAINER Apolo Yasuda "apolo.yasuda@ge.com"

WORKDIR root

VOLUME /build

RUN apt-get update \
&& apt-get install -y apt-transport-https \
&& apt-get install -y libpq-dev gcc

#RUN pip install --no-cache-dir -r requirements.txt

#
# The run to-be detail
#
# docker run --network host -v $(pwd):/build -e DIND_PATH="" --env-file v1beta.list -i enterpriseconnect/agent:v1beta
#
CMD cd /build/$DIND_PATH && ls -la  && ./dind.sh