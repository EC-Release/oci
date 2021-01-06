FROM node:alpine
FROM node:7

MAINTAINER Gayatri Tagade "gayatri.tagade@ge.com"

USER root
WORKDIR /root/temp

ARG EC_PUB_KEY
ARG EC_PRVT_KEY

RUN echo $EC_PUB_KEY | base64 -d > service.cer
RUN echo $EC_PRVT_KEY | base64 -d > service.key

WORKDIR /root

# cloud foundry empty dirs docker binding issue. exact files in run time to workaround 
RUN tar -zcf temp.tar.gz ./temp && rm -Rf ./temp && ls -al
# get cf cli for outdated CF instance 
RUN curl -L "https://packages.cloudfoundry.org/stable?release=linux64-binary&version=6.49.0&source=github-rel" | tar -zx && \
mv cf /usr/local/bin && \
cf --version
RUN ["/bin/bash", "-c", "wget -q --show-progress -O v1.linux64.sh https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/service1.x/v1.linux64.txt"]
RUN ls -al && chmod 755 v1.linux64.sh
CMD ./v1.linux64.sh
