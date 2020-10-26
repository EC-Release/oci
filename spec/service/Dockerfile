FROM node:alpine
FROM node:7

MAINTAINER Gayatri Tagade "gayatri.tagade@ge.com"

USER root
WORKDIR /home/root

ARG EC_PUB_KEY
ARG EC_PRVT_KEY

COPY ./ec-px-service ./
COPY ./api_linux ./
COPY ./run.sh ./

RUN npm install
RUN echo $EC_PUB_KEY | base64 -d > service.cer
RUN echo $EC_PRVT_KEY | base64 -d > service.key
RUN chmod 755 api_linux
RUN chmod 755 run.sh

CMD export EC_PUB_KEY="$(cat service.cer)" && \
export EC_PRVT_KEY="$(cat service.key)" && \
./run.sh && node ./app.js
