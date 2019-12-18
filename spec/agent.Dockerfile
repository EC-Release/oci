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
WORKDIR /root

COPY ./*.yml ./

RUN wget -O ./ecagent_linux_sys.tar.gz https://raw.githubusercontent.com/Enterprise-connect/ec-x-sdk/v1.hokkaido.212/dist/ecagent_linux_sys.tar.gz \
  && tar -xvzf ./ecagent_linux_sys.tar.gz \
  && rm ./ecagent_linux_sys.tar.gz \
  && ls -al

CMD sed -i 's@{EC_AID}@'"$EC_AID"'@g' ~/${EC_MOD}.yml \
 && sed -i 's@{EC_TID}@'"$EC_TID"'@g' ~/${EC_MOD}.yml \
 && sed -i 's@{EC_CID}@'"$EC_CID"'@g' ~/${EC_MOD}.yml \
 && sed -i 's@{EC_CSC}@'"$EC_CSC"'@g' ~/${EC_MOD}.yml \
 && sed -i 's@{EC_OA2}@'"$EC_OA2"'@g' ~/${EC_MOD}.yml \
 && sed -i 's@{EC_DUR}@'"$EC_DUR"'@g' ~/${EC_MOD}.yml \
 && sed -i 's@{EC_DBG}@'"$EC_DBG"'@g' ~/${EC_MOD}.yml \
 && sed -i 's@{EC_ZON}@'"$EC_ZON"'@g' ~/${EC_MOD}.yml \
 && sed -i 's@{EC_GRP}@'"$EC_GRP"'@g' ~/${EC_MOD}.yml \
 && sed -i 's@{EC_CPS}@'"$EC_CPS"'@g' ~/${EC_MOD}.yml \
 && sed -i 's@{EC_LPT}@'"$EC_LPT"'@g' ~/${EC_MOD}.yml \
 && sed -i 's@{EC_GPT}@'"$EC_GPT"'@g' ~/${EC_MOD}.yml \
 && sed -i 's@{EC_RPT}@'"$EC_RPT"'@g' ~/${EC_MOD}.yml \
 && sed -i 's@{EC_RHT}@'"$EC_RHT"'@g' ~/${EC_MOD}.yml \
 && sed -i 's@{EC_HST}@'"$EC_HST"'@g' ~/${EC_MOD}.yml \
 && sed -i 's@{EC_SST}@'"$EC_SST"'@g' ~/${EC_MOD}.yml \
 && sed -i 's@{EC_TKN}@'"$EC_TKN"'@g' ~/${EC_MOD}.yml \
 && sed -i 's@{EC_PXY}@'"$EC_PXY"'@g' ~/${EC_MOD}.yml \
 && sed -i 's@{EC_PLG}@'"$EC_PLG"'@g' ~/${EC_MOD}.yml \
 && cat ./${EC_MOD}.yml \
 && ./ecagent_linux_sys -cfg ${EC_MOD}.yml