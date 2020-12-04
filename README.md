[![Build Status](https://travis-ci.com/Enterprise-connect/oci.svg?branch=v1)](https://travis-ci.com/github/Enterprise-connect/oci/branches)

# Agent API DB Usage for Docker Users

```bash
# generate the adm hash. valid for 90 days
docker run enterpriseconnect/agent:v1.2beta -hsh -pvk <base64 private key> -pbk <base64 public key>

//interact with the agent db
docker run -it -e EC_PPS=<my adm hash> enterpriseconnect/api:v1.2beta -oa2 https://ec-oauth-oaep.herokuapp.com/oauth/token -url <my-app db url, e.g. https://ng-webui-db-4.herokuapp.com/v1.2beta/ec/api -cid <dev/cert id>

//interact with the container log
docker run -it enterpriseconnect/agent:v1.2beta -log -url https://ng-webui.herokuapp.com/v1.2beta/ec/log -tkn
```



