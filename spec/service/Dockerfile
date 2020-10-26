FROM node:alpine
FROM node:7

MAINTAINER Gayatri Tagade "gayatri.tagade@ge.com"

USER node
WORKDIR /home/node

ARG EC_PUB_KEY
ARG EC_PRVT_KEY

COPY ./ec-px-service ./
COPY ./api_linux ./
COPY ./run.sh ./

USER root
RUN chmod 775 api_linux
RUN chmod 775 run.sh

USER node
RUN npm install
RUN echo $EC_PUB_KEY | base64 -d > service.cer
RUN echo $EC_PRVT_KEY | base64 -d > service.key

CMD export EC_PUB_KEY="$(cat service.cer)" && \
export EC_PRVT_KEY="$(cat service.key)" && \
./run.sh && node ./app.js
