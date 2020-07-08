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

#arg is rewritten by docker build
ARG EC_REV=v1.hokkaido.212

COPY ./*.yml ./

RUN wget -O ./ecagent_linux_sys.tar.gz https://raw.githubusercontent.com/Enterprise-connect/sdk/${EC_REV}/dist/ecagent_linux_sys.tar.gz \
  && tar -xvzf ./ecagent_linux_sys.tar.gz \
  && rm ./ecagent_linux_sys.tar.gz \
  && ls -al

CMD sed -i 's@{EC_AID}@'"$conf.aid"'@g' ~/${conf.mod}.yml \
 && sed -i 's@{EC_TID}@'"$conf.tid"'@g' ~/${conf.mod}.yml \
 && sed -i 's@{EC_CID}@'"$conf.cid"'@g' ~/${conf.mod}.yml \
 && sed -i 's@{EC_CSC}@'"$conf.csc"'@g' ~/${conf.mod}.yml \
 && sed -i 's@{EC_OA2}@'"$conf.oa2"'@g' ~/${conf.mod}.yml \
 && sed -i 's@{EC_DUR}@'"$conf.dur"'@g' ~/${conf.mod}.yml \
 && sed -i 's@{EC_DBG}@'"$conf.dbg"'@g' ~/${conf.mod}.yml \
 && sed -i 's@{EC_ZON}@'"$conf.zon"'@g' ~/${conf.mod}.yml \
 && sed -i 's@{EC_GRP}@'"$conf.grp"'@g' ~/${conf.mod}.yml \
 && sed -i 's@{EC_CPS}@'"$conf.cps"'@g' ~/${conf.mod}.yml \
 && sed -i 's@{EC_LPT}@'"$conf.lpt"'@g' ~/${conf.mod}.yml \
 && sed -i 's@{EC_GPT}@'"$conf.gpt"'@g' ~/${conf.mod}.yml \
 && sed -i 's@{EC_RPT}@'"$conf.rpt"'@g' ~/${conf.mod}.yml \
 && sed -i 's@{EC_RHT}@'"$conf.rht"'@g' ~/${conf.mod}.yml \
 && sed -i 's@{EC_HST}@'"$conf.hst"'@g' ~/${conf.mod}.yml \
 && sed -i 's@{EC_SST}@'"$conf.sst"'@g' ~/${conf.mod}.yml \
 && sed -i 's@{EC_TKN}@'"$conf.tkn"'@g' ~/${conf.mod}.yml \
 && sed -i 's@{EC_PXY}@'"$conf.pxy"'@g' ~/${conf.mod}.yml \
 && sed -i 's@{EC_PLG}@'"$conf.plg"'@g' ~/${conf.mod}.yml \
 && cat ./${conf.mod}.yml \
 && ./ecagent_linux_sys -cfg ${conf.mod}.yml
