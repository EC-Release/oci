FROM node:alpine
FROM node:7

MAINTAINER Gayatri Tagade "gayatri.tagade@ge.com"

USER root
WORKDIR /root/temp

ARG EC_PUB_KEY
ARG EC_PRVT_KEY

COPY ./ec-px-service ./
COPY ./api_linux ./
COPY ./run.sh ./

RUN chmod 775 ./api_linux
RUN chmod 775 ./run.sh

RUN npm install
RUN echo $EC_PUB_KEY | base64 -d > service.cer
RUN echo $EC_PRVT_KEY | base64 -d > service.key

WORKDIR /root
RUN ./run.sh && tar -zcvf temp.tar.gz ./temp && rm -Rf ./temp
RUN chmod 644 temp.tar.gz && ls -al

CMD ls -al && tar -xvfz --strip-components=1 temp.tar.gz && \
ls -al && rm temp.tar.gz && \
export EC_PUB_KEY="$(cat service.cer)" && \
export EC_PRVT_KEY="$(cat service.key)" && \
./run.sh && node ./app.js
