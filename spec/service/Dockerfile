FROM node:alpine
FROM node:7

MAINTAINER Gayatri Tagade "gayatri.tagade@ge.com"

USER root
WORKDIR /root/temp

ARG EC_PUB_KEY
ARG EC_PRVT_KEY

COPY ./ec-px-service ./
COPY ./api_linux ./

RUN chmod 775 ./api_linux

RUN npm install
RUN echo $EC_PUB_KEY | base64 -d > service.cer
RUN echo $EC_PRVT_KEY | base64 -d > service.key

WORKDIR /root
COPY ./run.sh ./
RUN chmod 775 ./run.sh
# cloud foundry empty dirs docker binding issue. exact files in run time to workaround 
RUN tar -zcf temp.tar.gz ./temp && rm -Rf ./temp && ls -al
# get cf cli for outdated CF instance 
RUN curl -L "https://packages.cloudfoundry.org/stable?release=linux64-binary&version=6.49.0&source=github-rel" | tar -zx && \
mv cf /usr/local/bin && \
cf --version
RUN ["/bin/bash","-c","source <(wget -O -https://ec-release.github.io/sdk/scripts/service1.x/v1beta.linux64.txt)"]
RUN ls -al && chmod 755 service.sh
CMD ./run.sh
