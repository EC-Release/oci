[![Build Status](https://travis-ci.com/Enterprise-connect/oci.svg?branch=v1)](https://travis-ci.com/github/Enterprise-connect/oci/branches)

# Agent API DB Usage for Docker Users

## For EC Agent CLI Expert
Some [useful command can be found here.](https://github.com/EC-Release/sdk/tree/disty/scripts/api#agent-db-usage)

## generate the admin hash valid for 90 days
See [steps to create admin hash](https://github.com/EC-Release/sdk/tree/disty/scripts/api#admin-hash)

## interact with the agent db
```bash
# get all keys in the db
docker run -it -e EC_PPS=<my adm hash> enterpriseconnect/api:v1.2beta \
-oa2 https://ec-oauth-oaep.herokuapp.com/oauth/token \
-url <my-app db url, e.g. https://ng-webui.herokuapp.com/v1.2beta/ec/api \
-cid <dev/cert id>

# get value in the db by key
docker run -it -e EC_PPS=<my adm hash> enterpriseconnect/api:v1.2beta \
-oa2 https://ec-oauth-oaep.herokuapp.com/oauth/token \
-url <my-app db url, e.g. https://ng-webui.herokuapp.com/v1.2beta/ec/api/<key> \
-cid <dev/cert id>

# create a key-value in the db
docker run -it -e EC_PPS=<my adm hash> enterpriseconnect/api:v1.2beta \
-oa2 https://ec-oauth-oaep.herokuapp.com/oauth/token \
-url <my-app db url, e.g. https://ng-webui.herokuapp.com/v1.2beta/ec/api/<key> \
-cid <dev/cert id> -mtd POST -dat '{"hello":"world","and":"others"}'

# delete a key-value in the db
docker run -it -e EC_PPS=<my adm hash> enterpriseconnect/api:v1.2beta \
-oa2 https://ec-oauth-oaep.herokuapp.com/oauth/token \
-url <my-app db url, e.g. https://ng-webui.herokuapp.com/v1.2beta/ec/api/<key> \
-cid <dev/cert id> -mtd DELETE
```

## interact with the container
```bash
# remote access the container logger in real-time 
docker run -it enterpriseconnect/agent:v1.2beta -log -url https://ng-webui.herokuapp.com/v1.2beta/ec/log -tkn
```

## Deploy the Agent API via the OCI Spec
```bash
# Deploy in Cloud Foundry
cf push my-app --docker-image enterpriseconnect/api:v1.2beta --no-start

#
# Env Variables Needed in the container
# CA_PPRS: <adm hash>
# EC_AGT_GRP: <v1.2 gateway group name>
# EC_AGT_MODE: <x mode>
# EC_API_APP_NAME: <app name as part of the app context path>
# EC_API_DEV_ID: <dev/cert id>
# EC_API_OA2: https://ec-oauth-oaep.herokuapp.com/oauth/token
# EC_PORT: :17990
# EC_PUBCRT: <base64 public cert>
# EC_PVTKEY: <base64 private key>
# EC_SEED_HOST: <the URL endpoint of this app, e.g. http://<app url>/v1.2beta/<app name> >
# EC_SEED_NODE: <the initial upstream node URL in the blockchain cluster, e.g. https://ng-webui-db-4.herokuapp.com/v1.2beta/ec >
#
# set the above env vars
cf set-env my-app <env var> <value>

# start the app
cf start my-app
