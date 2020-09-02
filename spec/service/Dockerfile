FROM node:alpine

MAINTAINER Gayatri Tagade "gayatri.tagade@ge.com"

ENV SERVICE_BRANCH=v1beta

WORKDIR /build

# COPY ./conf.yaml /build/conf.yaml
RUN wget https://gitlab.com/digital-fo/connectivity/enterprise-connect/predix/ec-px-service/-/archive/v1beta/ec-px-service-v1beta.tar.gz \
  && tar -xvzf ec-px-service-v1beta.tar.gz --strip-components 1 && rm ec-px-service-v1beta.tar.gz \
  && wget https://gitlab.com/digital-fo/connectivity/enterprise-connect/predix/ec-px-service-assets/-/archive/v1beta/ec-px-service-assets-v1beta.tar.gz \
  && tar -xvzf ec-px-service-assets-v1beta.tar.gz --strip-components 1 -C $(pwd)/ec-px-service-assets \
  && ls -al ec-px-service-assets \
  && wget https://gitlab.com/digital-fo/connectivity/enterprise-connect/predix/ec-px-service-webui/-/archive/v1beta/ec-px-service-webui-v1beta.tar.gz \
  && tar -xvzf ec-px-service-webui-v1beta.tar.gz --strip-components 1 -C $(pwd)/ec-px-service-webui \
  && ls -al ec-px-service-assets

CMD ./build.sh