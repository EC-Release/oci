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


FROM golang:1.12.16-buster

MAINTAINER Apolo Yasuda "apolo.yasuda@ge.com"
    
RUN go get gopkg.in/yaml.v2
RUN go get github.com/gorilla/websocket
RUN go get github.com/pborman/uuid
RUN go get github.com/fatih/color
RUN go get github.com/fullsailor/pkcs7
RUN go get golang.org/x/tools/cmd/godoc
RUN go get github.com/vishvananda/netlink
RUN go get github.com/mwitkow/go-http-dialer
RUN go get github.com/golang/protobuf/proto
RUN go get google.golang.org/grpc
RUN go get github.com/go-stack/stack
RUN go get github.com/inconshreveable/log15
RUN go get github.com/pmylund/go-cache
RUN go get github.com/surgemq/message
RUN go get github.com/surgemq/surgemq
RUN go get github.com/surgemq/surgemq/service
RUN go get google.golang.org/grpc
RUN go get golang.org/x/lint/golint
RUN go get gopkg.in/cheggaaa/pb.v1
RUN go get github.com/google/uuid
RUN go get github.com/docker/docker/client \
&& rm -Rf ${GOPATH}/src/github.com/docker/docker/vendor/github.com/docker/go-connections/nat
RUN go get github.com/docker/go-connections/nat
RUN go get golang.org/x/crypto/ssh/terminal
RUN go get golang.org/x/lint/golint
RUN go get github.com/creack/pty
RUN go get github.com/jasonlvhit/gocron
RUN go get github.com/boltdb/bolt

#add gosec for SAST
RUN go get github.com/securego/gosec/cmd/gosec

WORKDIR root

VOLUME /build

#
# The run to-be detail
#
# docker run --network host -v $(pwd):/build -e DIND_PATH="" --env-file v1beta.list -i enterpriseconnect/agent:v1beta
#
CMD cd /build/$DIND_PATH && ls -la  && ./dind.sh
