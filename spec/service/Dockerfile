FROM node:alpine
FROM node:12

MAINTAINER Gayatri Tagade "gayatri.tagade@ge.com"

ENV SERVICE_BRANCH=v1beta
ENV ENV=v1beta.sendai.1080
ENV EC_PRVT_PWD=EC_PRVT_PWD
ENV EC_PRVT_KEY=EC_PRVT_KEY
ENV EC_PUB_KEY=EC_PUB_KEY

WORKDIR /build

ARG APP
ARG HOST
ARG PROXY_URL
ARG EC_REV
ARG BUILD_NUMBER
ARG PROJECT_NAME
ARG ADMIN_USR
ARG ADMIN_PWD
ARG ZAC_UAA
ARG ZAC_URL
ARG ZAC_SERVICE_ID
ARG ZAC_CLIENT_ID
ARG ZAC_CLIENT_SECRET
ARG NUREGO_FEATURE_ID
ARG NUREGO_API_KEY
ARG NR_KEY
ARG NUREGO_TKN_INS
ARG NUREGO_TKN_PWD
ARG NUREGO_TKN_USR
ARG NUREGO_USAGE_FEATURE_ID

ARG NUREGO_ENDPOINT
ARG NUREGO_TKN_URL

COPY ./ec-px-service /build/
COPY ./api_linux /build/

RUN npm install

CMD chmod 755 build.sh
CMD chmod 755 api_linux
# CMD eval "sed -i -e 's#{HOST}#${APP}-${ENV}.${HOST}#g' ./assets/swagger.json"
CMD eval "sed -i -e 's#{BASE}#${EC_REV}#g' ./assets/swagger.json"
CMD eval "sed -i -e 's#{ENV}#${ENV}#g' ./assets/swagger.json"
CMD ./api_linux
CMD node ./app.js
