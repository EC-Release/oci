FROM node:alpine

MAINTAINER Gayatri Tagade "gayatri.tagade@ge.com"

ENV SERVICE_BRANCH=v1beta
ENV ENV=v1beta.sendai.1080

WORKDIR /build

ARG CF_USER
ARG CF_PWD 
ENV EC_APP_NAME
ENV EC_SERVICE_HOST_SUB_DOMAIN
ENV PROXY_URL
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

ENV NUREGO_ENDPOINT=https://am-staging.nurego.com/v1
ENV NUREGO_TKN_URL=https://am-staging.nurego.com/v1/auth/token

# COPY ./conf.yaml /build/conf.yaml
RUN wget https://$ACCESS_TOKEN@gitlab.com/digital-fo/connectivity/enterprise-connect/predix/ec-px-service/-/archive/v1beta/ec-px-service-v1beta.tar.gz \
  && tar -xvzf ec-px-service-v1beta.tar.gz --strip-components 1 && rm ec-px-service-v1beta.tar.gz \
  && wget https://$ACCESS_TOKEN@gitlab.com/digital-fo/connectivity/enterprise-connect/predix/ec-px-service-assets/-/archive/v1beta/ec-px-service-assets-v1beta.tar.gz \
  && tar -xvzf ec-px-service-assets-v1beta.tar.gz --strip-components 1 -C $(pwd)/ec-px-service-assets \
  && ls -al ec-px-service-assets \
  && wget https://$ACCESS_TOKEN@gitlab.com/digital-fo/connectivity/enterprise-connect/predix/ec-px-service-webui/-/archive/v1beta/ec-px-service-webui-v1beta.tar.gz \
  && tar -xvzf ec-px-service-webui-v1beta.tar.gz --strip-components 1 -C $(pwd)/ec-px-service-webui \
  && ls -al ec-px-service-webui

CMD chmod 755 ./build.sh
CMD ./build.sh -app $EC_APP_NAME -host $EC_SERVICE_HOST_SUB_DOMAIN \
-p $PROXY_URL -r $EC_REV \
-b $BUILD_NUMBER -e $PROJECT_NAME \
-ecadm $ADMIN_USR -ecpwd $ADMIN_PWD \
-zactokenurl $ZAC_UAA \
-zacurl $ZAC_URL \
-zacsvcid $ZAC_SERVICE_ID \
-zaccid $ZAC_CLIENT_ID \
-zaccscrt $ZAC_CLIENT_SECRET \
-nrgfeatrid $NUREGO_FEATURE_ID \
-nrgkey $NUREGO_API_KEY \
-newrelickey $NR_KEY
